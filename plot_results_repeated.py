#!/usr/bin/env python3
import argparse
import csv
import re
import subprocess
from collections import defaultdict
from pathlib import Path

import matplotlib.pyplot as plt

BLOCK_RE = re.compile(
    r"--\s*(?:r|h)=([0-9.]+)[^\n]*\n(.*?)(?=\n--\s*(?:r|h)=|\Z)",
    re.S,
)
EXEC_RE = re.compile(r"Execution Time:\s*([0-9.]+)\s*ms")


def parse_results(text: str):
    points = []
    for radius_s, block in BLOCK_RE.findall(text):
        if "Parallel Seq Scan on points_1m" in block:
            plan = "Parallel Seq Scan"
        elif "Seq Scan on points_1m" in block:
            plan = "Seq Scan"
        elif "Parallel Bitmap Heap Scan on points_1m" in block:
            plan = "Parallel Bitmap Heap Scan"
        elif "Bitmap Heap Scan on points_1m" in block:
            plan = "Bitmap Heap Scan"
        elif "Index Scan using points_1m_geom_gix" in block:
            plan = "Index Scan"
        else:
            plan = "Other"

        m_exec = EXEC_RE.search(block)
        if not m_exec:
            continue

        points.append(
            {
                "radius": float(radius_s),
                "exec_ms": float(m_exec.group(1)),
                "plan": plan,
            }
        )
    points.sort(key=lambda d: d["radius"])
    return points


def percentile(values, p):
    vals = sorted(values)
    if not vals:
        return None
    if len(vals) == 1:
        return vals[0]
    idx = (len(vals) - 1) * p
    lo = int(idx)
    hi = min(lo + 1, len(vals) - 1)
    frac = idx - lo
    return vals[lo] + (vals[hi] - vals[lo]) * frac


def run_sql(psql, db, sql_path, rpc=None):
    cmd = [
        psql,
        "-X",
        "-q",
        "-v",
        "ON_ERROR_STOP=1",
        "-d",
        db,
        "-f",
        str(sql_path),
    ]
    if rpc is not None:
        cmd.extend(["-v", f"rpc={rpc}"])
    completed = subprocess.run(
        cmd,
        text=True,
        capture_output=True,
        check=True,
    )
    return completed.stdout


def plot(
    stats_default,
    stats_compare,
    output,
    theme,
    repeats,
    title,
    xlabel,
):
    if theme == "dark":
        plt.style.use("dark_background")
        c_default = "#7aa2f7"
        c_compare = "#f7768e"
        grid_alpha = 0.25
    else:
        plt.style.use("default")
        c_default = "#1f77b4"
        c_compare = "#d62728"
        grid_alpha = 0.3

    fig, ax = plt.subplots(figsize=(10, 6))
    for label, stats, color in [
        ("rpc=4", stats_default, c_default),
        ("rpc=30", stats_compare, c_compare),
    ]:
        xs = [r for r, _ in stats]
        med = [row["median"] for _, row in stats]
        p95 = [row["p95"] for _, row in stats]
        p25 = [row["p25"] for _, row in stats]
        p75 = [row["p75"] for _, row in stats]

        ax.plot(
            xs,
            med,
            color=color,
            linewidth=2.0,
            marker="o",
            label=f"{label} median",
        )
        ax.plot(
            xs,
            p95,
            color=color,
            linewidth=1.4,
            linestyle="--",
            marker="x",
            alpha=0.9,
            label=f"{label} p95",
        )
        ax.fill_between(xs, p25, p75, color=color, alpha=0.15)

    ax.set_title(f"{title} (Repeated {repeats}x): Median and p95")
    ax.set_xlabel(xlabel)
    ax.set_ylabel("Execution Time (ms)")
    ax.grid(True, linestyle="--", alpha=grid_alpha)
    ax.legend(loc="upper left")
    fig.tight_layout()
    output.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output, dpi=170)
    print(f"Wrote repeated sweep graph: {output}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--psql", default="psql")
    parser.add_argument("--db", default="spatial_rpc_lab")
    parser.add_argument("--repeats", type=int, default=5)
    parser.add_argument("--rpc", type=int, default=30)
    parser.add_argument("--default-sql", required=True)
    parser.add_argument("--compare-sql", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--raw-csv", required=True)
    parser.add_argument("--title", required=True)
    parser.add_argument("--xlabel", required=True)
    parser.add_argument("--theme", choices=["light", "dark"], default="light")
    args = parser.parse_args()

    default_data = defaultdict(list)
    compare_data = defaultdict(list)
    default_plans = defaultdict(list)
    compare_plans = defaultdict(list)

    csv_rows = []
    for run_idx in range(1, args.repeats + 1):
        print(f"Run {run_idx}/{args.repeats}: rpc=4")
        default_out = run_sql(
            args.psql,
            args.db,
            Path(args.default_sql),
        )
        default_points = parse_results(default_out)

        print(f"Run {run_idx}/{args.repeats}: rpc={args.rpc}")
        compare_out = run_sql(
            args.psql,
            args.db,
            Path(args.compare_sql),
            rpc=args.rpc,
        )
        compare_points = parse_results(compare_out)

        for p in default_points:
            default_data[p["radius"]].append(p["exec_ms"])
            default_plans[p["radius"]].append(p["plan"])
            csv_rows.append(
                ["rpc=4", run_idx, p["radius"], p["exec_ms"], p["plan"]]
            )

        for p in compare_points:
            compare_data[p["radius"]].append(p["exec_ms"])
            compare_plans[p["radius"]].append(p["plan"])
            csv_rows.append(
                [
                    f"rpc={args.rpc}",
                    run_idx,
                    p["radius"],
                    p["exec_ms"],
                    p["plan"],
                ]
            )

    output_csv = Path(args.raw_csv)
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    with output_csv.open("w", newline="") as fh:
        writer = csv.writer(fh)
        writer.writerow(["series", "run", "radius", "exec_ms", "plan"])
        writer.writerows(csv_rows)
    print(f"Wrote repeated raw data: {output_csv}")

    def compute_stats(data, plans):
        rows = []
        for radius in sorted(data.keys()):
            vals = data[radius]
            rows.append(
                (
                    radius,
                    {
                        "median": percentile(vals, 0.5),
                        "p95": percentile(vals, 0.95),
                        "p25": percentile(vals, 0.25),
                        "p75": percentile(vals, 0.75),
                        "plan_mode": max(
                            set(plans[radius]),
                            key=plans[radius].count,
                        ),
                    },
                )
            )
        return rows

    default_stats = compute_stats(default_data, default_plans)
    compare_stats = compute_stats(compare_data, compare_plans)
    plot(
        default_stats,
        compare_stats,
        Path(args.output),
        args.theme,
        args.repeats,
        args.title,
        args.xlabel,
    )


if __name__ == "__main__":
    main()
