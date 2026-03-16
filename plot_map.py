#!/usr/bin/env python3
import argparse
import math
from pathlib import Path

import geopandas as gpd
import matplotlib.pyplot as plt
import pandas as pd
from shapely.geometry import Point, box


def build_gdf(csv_path: Path):
    df = pd.read_csv(csv_path)
    geometry = gpd.points_from_xy(df["x"], df["y"])
    return gpd.GeoDataFrame(df, geometry=geometry, crs="EPSG:3857")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--sample-csv", required=True)
    parser.add_argument("--hits-csv", required=True)
    parser.add_argument("--radii", required=True)
    parser.add_argument("--hit-radius", type=float, required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    sample = build_gdf(Path(args.sample_csv))
    hits = build_gdf(Path(args.hits_csv))

    center = Point(0, 0)
    radii = [float(x) for x in args.radii.split(",") if x.strip()]
    radii = sorted(radii)
    circles = gpd.GeoDataFrame(
        {"radius_m": radii},
        geometry=[center.buffer(r) for r in radii],
        crs="EPSG:3857",
    )

    domain = gpd.GeoDataFrame(
        {"name": ["data_extent"]},
        geometry=[box(-50000, -50000, 50000, 50000)],
        crs="EPSG:3857",
    )

    fig, ax = plt.subplots(figsize=(9, 9))

    domain.boundary.plot(
        ax=ax, color="#555555", linewidth=1.1, label="dataset extent"
    )
    sample.plot(
        ax=ax, markersize=2, color="#4c78a8", alpha=0.22, label="sampled points"
    )
    circles.boundary.plot(ax=ax, linewidth=1.6, color="#f58518", alpha=0.8)
    hits.plot(
        ax=ax,
        markersize=7,
        color="#b279a2",
        alpha=0.8,
        label=f"sampled hits at r={int(args.hit_radius)}m",
    )

    ax.scatter(
        [0], [0], s=60, marker="x", color="black", label="query center (0,0)"
    )

    angles_deg = [20, 40, 65, 95, 125, 155, 210, 250, 300, 335]
    for i, r in enumerate(radii):
        theta = math.radians(angles_deg[i % len(angles_deg)])
        x = r * math.cos(theta)
        y = r * math.sin(theta)
        ax.annotate(
            f"r={int(r)}m",
            xy=(x, y),
            xytext=(4, 4),
            textcoords="offset points",
            fontsize=9,
            bbox={"facecolor": "white", "alpha": 0.7, "edgecolor": "none"},
        )

    ax.set_title("PostGIS Spatial Area and ST_DWithin Query Geometry")
    ax.set_xlabel("X (meters, EPSG:3857)")
    ax.set_ylabel("Y (meters, EPSG:3857)")
    ax.set_aspect("equal", adjustable="box")
    ax.grid(True, linestyle="--", alpha=0.25)
    ax.legend(loc="upper right")

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    fig.tight_layout()
    fig.savefig(out, dpi=170)
    print(f"Wrote map: {out}")


if __name__ == "__main__":
    main()
