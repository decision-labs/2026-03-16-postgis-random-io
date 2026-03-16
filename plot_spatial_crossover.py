#!/usr/bin/env python3
import argparse
import re
from pathlib import Path

import matplotlib.pyplot as plt

MARK_RE = re.compile(r"@ sel=([0-9.]+) mode=([a-z_]+)")
PLAN_COST_RE = re.compile(r"\(cost=[0-9.]+\.\.[0-9.]+")
EXEC_RE = re.compile(r"Execution Time:\s*([0-9.]+)\s*ms")


def extract_total_cost(block: str):
    m = PLAN_COST_RE.search(block)
    if not m:
        return None
    part = m.group(0).split("..", 1)[1]
    try:
        return float(part)
    except ValueError:
        return None


def parse(path: Path):
    lines = path.read_text().splitlines()
    points = []
    i = 0
    while i < len(lines):
        mark = MARK_RE.search(lines[i])
        if not mark:
            i += 1
            continue
        sel = float(mark.group(1))
        mode = mark.group(2)
        block_lines = []
        i += 1
        while i < len(lines) and not MARK_RE.search(lines[i]):
            block_lines.append(lines[i])
            i += 1
        block = "\n".join(block_lines)
        points.append({
            "sel": sel,
            "mode": mode,
            "cost": extract_total_cost(block),
            "exec_ms": (
                float(EXEC_RE.search(block).group(1))
                if EXEC_RE.search(block)
                else None
            ),
        })
    return points


def split_mode(points, mode):
    rows = [p for p in points if p["mode"] == mode]
    rows.sort(key=lambda p: p["sel"])
    return rows


def crossover_x(xs, ys_a, ys_b):
    for i in range(len(xs) - 1):
        d0 = ys_a[i] - ys_b[i]
        d1 = ys_a[i + 1] - ys_b[i + 1]
        if d0 == 0:
            return xs[i]
        if d0 * d1 < 0:
            x0, x1 = xs[i], xs[i + 1]
            return x0 + (0 - d0) * (x1 - x0) / (d1 - d0)
    return None


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--xlabel", default="Selectivity (%)")
    parser.add_argument(
        "--title",
        default="Spatial Planner Cost vs Runtime Crossover",
    )
    parser.add_argument("--theme", choices=["light", "dark"], default="light")
    args = parser.parse_args()

    if args.theme == "dark":
        plt.style.use("dark_background")
        grid_alpha = 0.25
    else:
        plt.style.use("default")
        grid_alpha = 0.3

    points = parse(Path(args.input))
    forced_idx = split_mode(points, "forced_index")
    forced_seq = split_mode(points, "forced_seq")
    planner = split_mode(points, "planner")
    if not forced_idx or not forced_seq or not planner:
        raise SystemExit("Missing planner/forced_index/forced_seq data")

    xs = [p["sel"] for p in forced_idx]
    idx_cost = [p["cost"] for p in forced_idx]
    seq_cost = [p["cost"] for p in forced_seq]
    idx_time = [p["exec_ms"] for p in forced_idx]
    seq_time = [p["exec_ms"] for p in forced_seq]
    planner_time = [p["exec_ms"] for p in planner]

    cost_cross = crossover_x(xs, idx_cost, seq_cost)
    time_cross = crossover_x(xs, idx_time, seq_time)

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 9), sharex=True)
    ax1.plot(xs, idx_cost, marker="D", label="forced index cost")
    ax1.plot(xs, seq_cost, marker="s", label="forced seq cost")
    if cost_cross is not None:
        ax1.axvline(
            cost_cross,
            linestyle="--",
            alpha=0.7,
            label=f"cost crossover ~{cost_cross:.2f}%",
        )
    ax1.set_ylabel("Estimated Cost")
    ax1.set_title(args.title)
    ax1.grid(True, linestyle="--", alpha=grid_alpha)
    ax1.legend()

    ax2.plot(xs, idx_time, marker="D", label="forced index runtime")
    ax2.plot(xs, seq_time, marker="s", label="forced seq runtime")
    ax2.plot(xs, planner_time, marker="o", label="planner chosen runtime")
    if time_cross is not None:
        ax2.axvline(
            time_cross,
            linestyle="--",
            alpha=0.7,
            label=f"runtime crossover ~{time_cross:.2f}%",
        )
    ax2.set_xlabel(args.xlabel)
    ax2.set_ylabel("Execution Time (ms)")
    ax2.grid(True, linestyle="--", alpha=grid_alpha)
    ax2.legend()

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    fig.tight_layout()
    fig.savefig(out, dpi=160)
    print(f"Wrote spatial crossover graph: {out}")


if __name__ == "__main__":
    main()
