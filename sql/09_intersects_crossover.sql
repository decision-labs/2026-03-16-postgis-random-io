\echo '== ST_Intersects crossover probe: planner vs forced index vs forced seq =='
RESET random_page_cost;
RESET seq_page_cost;
RESET effective_cache_size;

\echo '@ sel=0.01 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-500,-500,500,500,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-500,-500,500,500,3857));
\echo '@ sel=0.01 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-500,-500,500,500,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-500,-500,500,500,3857));
\echo '@ sel=0.01 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-500,-500,500,500,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-500,-500,500,500,3857));

\echo '@ sel=0.02 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-707,-707,707,707,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-707,-707,707,707,3857));
\echo '@ sel=0.02 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-707,-707,707,707,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-707,-707,707,707,3857));
\echo '@ sel=0.02 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-707,-707,707,707,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-707,-707,707,707,3857));

\echo '@ sel=0.03 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-866,-866,866,866,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-866,-866,866,866,3857));
\echo '@ sel=0.03 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-866,-866,866,866,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-866,-866,866,866,3857));
\echo '@ sel=0.03 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-866,-866,866,866,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-866,-866,866,866,3857));

\echo '@ sel=0.04 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1000,-1000,1000,1000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1000,-1000,1000,1000,3857));
\echo '@ sel=0.04 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1000,-1000,1000,1000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1000,-1000,1000,1000,3857));
\echo '@ sel=0.04 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1000,-1000,1000,1000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1000,-1000,1000,1000,3857));

\echo '@ sel=0.05 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1118,-1118,1118,1118,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1118,-1118,1118,1118,3857));
\echo '@ sel=0.05 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1118,-1118,1118,1118,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1118,-1118,1118,1118,3857));
\echo '@ sel=0.05 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1118,-1118,1118,1118,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1118,-1118,1118,1118,3857));

\echo '@ sel=0.10 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1581,-1581,1581,1581,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1581,-1581,1581,1581,3857));
\echo '@ sel=0.10 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1581,-1581,1581,1581,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1581,-1581,1581,1581,3857));
\echo '@ sel=0.10 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1581,-1581,1581,1581,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1581,-1581,1581,1581,3857));

\echo '@ sel=0.20 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-2236,-2236,2236,2236,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-2236,-2236,2236,2236,3857));
\echo '@ sel=0.20 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-2236,-2236,2236,2236,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-2236,-2236,2236,2236,3857));
\echo '@ sel=0.20 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-2236,-2236,2236,2236,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-2236,-2236,2236,2236,3857));

\echo '@ sel=0.50 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-3536,-3536,3536,3536,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-3536,-3536,3536,3536,3857));
\echo '@ sel=0.50 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-3536,-3536,3536,3536,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-3536,-3536,3536,3536,3857));
\echo '@ sel=0.50 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-3536,-3536,3536,3536,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-3536,-3536,3536,3536,3857));

\echo '@ sel=1.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-5000,-5000,5000,5000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-5000,-5000,5000,5000,3857));
\echo '@ sel=1.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-5000,-5000,5000,5000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-5000,-5000,5000,5000,3857));
\echo '@ sel=1.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-5000,-5000,5000,5000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-5000,-5000,5000,5000,3857));

\echo '@ sel=2.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-7071,-7071,7071,7071,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-7071,-7071,7071,7071,3857));
\echo '@ sel=2.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-7071,-7071,7071,7071,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-7071,-7071,7071,7071,3857));
\echo '@ sel=2.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-7071,-7071,7071,7071,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-7071,-7071,7071,7071,3857));

\echo '@ sel=5.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-11180,-11180,11180,11180,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-11180,-11180,11180,11180,3857));
\echo '@ sel=5.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-11180,-11180,11180,11180,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-11180,-11180,11180,11180,3857));
\echo '@ sel=5.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-11180,-11180,11180,11180,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-11180,-11180,11180,11180,3857));

\echo '@ sel=10.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-15811,-15811,15811,15811,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-15811,-15811,15811,15811,3857));
\echo '@ sel=10.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-15811,-15811,15811,15811,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-15811,-15811,15811,15811,3857));
\echo '@ sel=10.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-15811,-15811,15811,15811,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-15811,-15811,15811,15811,3857));

\echo '@ sel=20.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-22361,-22361,22361,22361,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-22361,-22361,22361,22361,3857));
\echo '@ sel=20.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-22361,-22361,22361,22361,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-22361,-22361,22361,22361,3857));
\echo '@ sel=20.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-22361,-22361,22361,22361,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-22361,-22361,22361,22361,3857));

\echo '@ sel=25.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-25000,-25000,25000,25000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-25000,-25000,25000,25000,3857));
\echo '@ sel=25.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-25000,-25000,25000,25000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-25000,-25000,25000,25000,3857));
\echo '@ sel=25.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-25000,-25000,25000,25000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-25000,-25000,25000,25000,3857));

\echo '@ sel=30.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-27386,-27386,27386,27386,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-27386,-27386,27386,27386,3857));
\echo '@ sel=30.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-27386,-27386,27386,27386,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-27386,-27386,27386,27386,3857));
\echo '@ sel=30.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-27386,-27386,27386,27386,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-27386,-27386,27386,27386,3857));

\echo '@ sel=35.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-29580,-29580,29580,29580,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-29580,-29580,29580,29580,3857));
\echo '@ sel=35.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-29580,-29580,29580,29580,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-29580,-29580,29580,29580,3857));
\echo '@ sel=35.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-29580,-29580,29580,29580,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-29580,-29580,29580,29580,3857));

\echo '@ sel=40.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-31623,-31623,31623,31623,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-31623,-31623,31623,31623,3857));
\echo '@ sel=40.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-31623,-31623,31623,31623,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-31623,-31623,31623,31623,3857));
\echo '@ sel=40.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-31623,-31623,31623,31623,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-31623,-31623,31623,31623,3857));

\echo '@ sel=50.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-35355,-35355,35355,35355,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-35355,-35355,35355,35355,3857));
\echo '@ sel=50.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-35355,-35355,35355,35355,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-35355,-35355,35355,35355,3857));
\echo '@ sel=50.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-35355,-35355,35355,35355,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-35355,-35355,35355,35355,3857));

\echo '@ sel=60.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-38730,-38730,38730,38730,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-38730,-38730,38730,38730,3857));
\echo '@ sel=60.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-38730,-38730,38730,38730,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-38730,-38730,38730,38730,3857));
\echo '@ sel=60.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-38730,-38730,38730,38730,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-38730,-38730,38730,38730,3857));

\echo '@ sel=70.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-41833,-41833,41833,41833,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-41833,-41833,41833,41833,3857));
\echo '@ sel=70.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-41833,-41833,41833,41833,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-41833,-41833,41833,41833,3857));
\echo '@ sel=70.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-41833,-41833,41833,41833,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-41833,-41833,41833,41833,3857));

RESET enable_seqscan;
RESET enable_indexscan;
RESET enable_bitmapscan;
