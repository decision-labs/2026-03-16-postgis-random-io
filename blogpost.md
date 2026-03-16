## The Real Cost of Spatial Random I/O (PostGIS Edition)

The recent plan-flip outage discussion around Clerk is a good reminder that sudden planner changes can have real production impact when a hot-path query crosses into a worse plan unexpectedly.

One way plan choice can go wrong is when `random_page_cost` is set from the intuition that SSDs make random I/O almost as cheap as sequential I/O. That intuition is common, but in real workloads it can shift plan boundaries in ways that do not match observed runtimes.

This post looks at that specific failure mode in a spatial context: how a miscalibrated `random_page_cost` can move crossover points and create a selectivity band where the chosen plan is not the fastest path.

Reference: [The real cost of random I/O](https://vondra.me/posts/the-real-cost-of-random-io/#)
Context: [Postgres FM transcript: Plan flips](https://postgres.fm/episodes/plan-flips/transcript)

---

### What I tested

Environment:

- PostgreSQL 17 (local)
- PostGIS 3.6.1
- 1,000,000 random points in `EPSG:3857`
- GiST index on `geom`

Dataset extent is synthetic and centered around `(0,0)`, approximately `[-50000, 50000]` meters on each axis.

Machine specs:

- macOS 14.6.1 (Darwin 23.6.0, build 23G93)
- Apple M1 (8 CPU cores)
- 16 GB RAM
- `arm64` architecture

---

### Baseline non-spatial crossover check

Before the spatial runs, I added a forced-plan crossover probe to visualize:

- planner-estimated cost curves (forced index vs forced seq)
- actual runtime curves (forced index vs forced seq)
- planner-chosen runtime

![Non-spatial cost/runtime crossover](../2026-03-16-random-io-cost/results/random_io_crossover.png)

In this run:

- estimated cost crossover was around `~1.55%`
- measured runtime crossover was around `~4.89%`

Implication: tuning decisions based only on default planner costs can be misleading. If cost crossover and runtime crossover do not align, there is a selectivity band where the planner may pick a slower path. In practice, this means `random_page_cost` should be calibrated against measured runtimes on your own workload, not treated as a one-size-fits-all constant.

---

### Spatial experiment 1: `ST_DWithin`

I swept radius selectivity from very small up to about 25% area-equivalent selectivity, and compared:

- default `random_page_cost=4`
- adjusted `random_page_cost=30`

![ST_DWithin sweep](results/spatial_random_io_sweep.png)

#### What stands out

- Both lines often use the same plan family (mostly bitmap / parallel bitmap) at medium-high selectivity.
- Runtime still diverges at many points even with the same plan family.

That happens because "same node type" is not "same actual work":

- different heap page hit/read mix
- different prefetch/caching behavior between runs
- different filter/recheck cost effects
- parallel worker timing and contention

So this chart is a good reminder: plan label alone is not enough; you need `BUFFERS`, execution time, and repeated runs.

---

### Spatial experiment 2: `geom && envelope` + `ST_Intersects`

I added a second sweep using square envelopes, which explicitly combines:

- bbox index filtering (`&&`)
- exact spatial predicate (`ST_Intersects`)

![ST_Intersects sweep](results/spatial_intersects_sweep.png)

#### Why this test matters

This pattern is common in real GIS queries. It highlights that:

- candidate set growth can change quickly with envelope size
- exact predicate checks add CPU work beyond raw I/O
- planner constants can shift choices, but runtime shape still depends heavily on data locality and cache state

---

### Query area map

The map below shows the synthetic extent, sampled points, query center, and selected radii used in the sweep.

![Spatial query area map](results/spatial_query_map.png)

---

### Practical takeaways

1. Treat `random_page_cost` as a workload calibration knob, not a fixed truth.
2. For PostGIS, evaluate both:
   - path family changes (index/bitmap/seq/parallel variants)
   - runtime changes within the same family.
3. Always pair `EXPLAIN (ANALYZE, BUFFERS)` with repeated measurements.
4. If you want to claim crossover behavior, plot both cost and runtime curves explicitly.

---

### Repro commands

From `2026-03-16-postgis-random-io/`:

- `make init`
- `make build`
- `make sweep`
- `make compare RPC=30`
- `make graph`
- `make isweep`
- `make icompare RPC=30`
- `make igraph`
- `make map`

From `2026-03-16-random-io-cost/`:

- `make crossover`
- `make graph-crossover`
