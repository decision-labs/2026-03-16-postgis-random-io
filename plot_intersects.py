#!/usr/bin/env python3
import argparse
import re
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

BLOCK_RE = re.compile(r"--\s*h=([0-9.]+)[^\n]*\n(.*?)(?=\n--\s*h=|\Z)", re.S)
EXEC_RE = re.compile(r"Execution Time:\s*([0-9.]+)\s*ms")


def parse_results(path: Path):
    text = path.read_text()
    points = []
    for h_s, block in BLOCK_RE.findall(text):
        if "Parallel Bitmap Heap Scan on points_1m" in block:
            plan = "Parallel Bitmap Heap Scan"
        elif "Parallel Seq Scan on points_1m" in block:
            plan = "Parallel Seq Scan"
        elif "Seq Scan on points_1m" in block:
            plan = "Seq Scan"
        elif "Bitmap Heap Scan on points_1m" in block:
            plan = "Bitmap Heap Scan"
        elif "Index Scan using points_1m_geom_gix" in block:
            plan = "Index Scan"
        else:
            plan = "Other"

        m_exec = EXEC_RE.search(block)
        if not m_exec:
            continue

        points.append({
            "half_side": float(h_s),
            "exec_ms": float(m_exec.group(1)),
            "plan": plan,
        })
    return sorted(points, key=lambda d: d["half_side"])


def marker_for_plan(plan: str):
    return {
        "Parallel Bitmap Heap Scan": "P",
        "Bitmap Heap Scan": "o",
        "Parallel Seq Scan": "^",
        "Seq Scan": "s",
        "Index Scan": "D",
    }.get(plan, "x")


def apply_theme(theme: str):
    if theme == "dark":
        plt.style.use("dark_background")
    else:
        plt.style.use("default")


def plot(default_points, compare_points, out_path: Path, theme: str):
    apply_theme(theme)
    fig, ax = plt.subplots(figsize=(10, 6))

    if theme == "dark":
        series = [("rpc=4", default_points, "#7aa2f7"),
                  ("rpc=30", compare_points, "#f7768e")]
        grid_alpha = 0.25
    else:
        series = [("rpc=4", default_points, "#1f77b4"),
                  ("rpc=30", compare_points, "#d62728")]
        grid_alpha = 0.3

    for label, points, color in series:
        x = [p["half_side"] for p in points]
        y = [p["exec_ms"] for p in points]
        ax.plot(x, y, color=color, linewidth=1.8, alpha=0.9, label=label)
        for p in points:
            ax.scatter(
                p["half_side"],
                p["exec_ms"],
                color=color,
                marker=marker_for_plan(p["plan"]),
                s=75,
                alpha=0.95,
            )

    # Annotate largest runtime gap between rpc settings.
    paired = []
    by_h = {p["half_side"]: p for p in compare_points}
    for p in default_points:
        q = by_h.get(p["half_side"])
        if q is not None:
            paired.append((p["half_side"], p["exec_ms"], q["exec_ms"], p["plan"], q["plan"]))
    if paired:
        h, y1, y2, p1, p2 = max(paired, key=lambda t: abs(t[1] - t[2]))
        y_top = max(y1, y2)
        ax.annotate(
            f"largest rpc gap @ h={int(h)}m",
            xy=(h, y_top),
            xytext=(10, 12),
            textcoords="offset points",
            fontsize=8,
            bbox={"facecolor": "#222" if theme == "dark" else "white",
                  "alpha": 0.7, "edgecolor": "none"},
        )

        # First envelope where chosen plan family differs between rpc settings.
        diff = [(hh, a, b) for hh, _, _, a, b in paired if a != b]
        if diff:
            hh, a, b = diff[0]
            yy = max(by_h[hh]["exec_ms"], next(x["exec_ms"] for x in default_points if x["half_side"] == hh))
            ax.annotate(
                f"plan diverges ({a} vs {b})",
                xy=(hh, yy),
                xytext=(12, -18),
                textcoords="offset points",
                fontsize=8,
                bbox={"facecolor": "#222" if theme == "dark" else "white",
                      "alpha": 0.7, "edgecolor": "none"},
            )

    ax.set_title("Spatial ST_Intersects Sweep: Runtime vs Envelope Half-Side")
    ax.set_xlabel("Envelope half-side (meters)")
    ax.set_ylabel("Execution Time (ms)")
    ax.grid(True, linestyle="--", alpha=grid_alpha)
    line_legend = ax.legend(loc="upper left", title="Series")

    plan_markers = []
    for plan in sorted({p["plan"] for p in default_points + compare_points}):
        plan_markers.append(
            Line2D(
                [0],
                [0],
                marker=marker_for_plan(plan),
                color="#e5e5e5" if theme == "dark" else "black",
                linestyle="None",
                markersize=7,
                label=plan,
            )
        )
    ax.add_artist(line_legend)
    ax.legend(handles=plan_markers, loc="upper right", title="Plan Marker")

    fig.tight_layout()
    out_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out_path, dpi=160)
    print(f"Wrote intersects graph: {out_path}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--default-out", required=True)
    parser.add_argument("--compare-out", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--theme", choices=["light", "dark"], default="light")
    args = parser.parse_args()

    default_points = parse_results(Path(args.default_out))
    compare_points = parse_results(Path(args.compare_out))

    if not default_points:
        raise SystemExit(f"No points parsed from {args.default_out}")
    if not compare_points:
        raise SystemExit(f"No points parsed from {args.compare_out}")

    plot(default_points, compare_points, Path(args.output), args.theme)


if __name__ == "__main__":
    main()
