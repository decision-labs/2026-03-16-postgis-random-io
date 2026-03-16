#!/usr/bin/env python3
import argparse
from pathlib import Path

import geopandas as gpd
import matplotlib.pyplot as plt
import pandas as pd
from shapely.geometry import box


def build_gdf(csv_path: Path):
    df = pd.read_csv(csv_path)
    geometry = gpd.points_from_xy(df["x"], df["y"])
    return gpd.GeoDataFrame(df, geometry=geometry, crs="EPSG:3857")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--sample-csv", required=True)
    parser.add_argument("--hits-csv", required=True)
    parser.add_argument("--half-sides", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--theme", choices=["light", "dark"], default="light")
    args = parser.parse_args()

    sample = build_gdf(Path(args.sample_csv))
    hits = build_gdf(Path(args.hits_csv))
    hsides = sorted(float(x) for x in args.half_sides.split(",") if x.strip())

    if args.theme == "dark":
        plt.style.use("dark_background")
        domain_color, sample_color = "#8a8a8a", "#7aa2f7"
        outline_color, hit_color = "#ff9e64", "#f7768e"
        center_color, label_bg, grid_alpha = "#f0f0f0", "#1e1e1e", 0.2
    else:
        plt.style.use("default")
        domain_color, sample_color = "#555555", "#4c78a8"
        outline_color, hit_color = "#f58518", "#b279a2"
        center_color, label_bg, grid_alpha = "black", "white", 0.25

    squares = gpd.GeoDataFrame(
        {"hside": hsides},
        geometry=[box(-h, -h, h, h) for h in hsides],
        crs="EPSG:3857",
    )
    domain = gpd.GeoDataFrame(
        {"name": ["data_extent"]},
        geometry=[box(-50000, -50000, 50000, 50000)],
        crs="EPSG:3857",
    )

    fig, ax = plt.subplots(figsize=(9, 9))
    domain.boundary.plot(
        ax=ax,
        color=domain_color,
        linewidth=1.1,
        label="dataset extent",
    )
    sample.plot(
        ax=ax,
        markersize=2,
        color=sample_color,
        alpha=0.22,
        label="sampled points",
    )
    squares.boundary.plot(ax=ax, linewidth=1.4, color=outline_color, alpha=0.8)
    hits.plot(
        ax=ax,
        markersize=6,
        color=hit_color,
        alpha=0.8,
        label=f"sampled hits at h={int(hsides[-1])}m",
    )
    ax.scatter(
        [0],
        [0],
        s=60,
        marker="x",
        color=center_color,
        label="query center (0,0)",
    )

    for h in hsides:
        ax.annotate(
            f"h={int(h)}m",
            xy=(h, h),
            xytext=(4, 4),
            textcoords="offset points",
            fontsize=9,
            bbox={"facecolor": label_bg, "alpha": 0.7, "edgecolor": "none"},
        )

    ax.set_title("PostGIS ST_Intersects Area and Envelope Sweep")
    ax.set_xlabel("X (meters, EPSG:3857)")
    ax.set_ylabel("Y (meters, EPSG:3857)")
    ax.set_aspect("equal", adjustable="box")
    ax.grid(True, linestyle="--", alpha=grid_alpha)
    ax.legend(loc="upper right")

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    fig.tight_layout()
    fig.savefig(out, dpi=170)
    print(f"Wrote intersects map: {out}")


if __name__ == "__main__":
    main()
