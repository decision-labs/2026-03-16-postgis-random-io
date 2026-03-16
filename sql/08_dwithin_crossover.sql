\echo '== ST_DWithin crossover probe: planner vs forced index vs forced seq =='
RESET random_page_cost;
RESET seq_page_cost;
RESET effective_cache_size;

\echo '@ sel=0.01 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 178);
\echo '@ sel=0.01 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 178);
\echo '@ sel=0.01 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 178);

\echo '@ sel=0.02 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 252);
\echo '@ sel=0.02 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 252);
\echo '@ sel=0.02 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 252);

\echo '@ sel=0.03 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 309);
\echo '@ sel=0.03 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 309);
\echo '@ sel=0.03 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 309);

\echo '@ sel=0.04 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 357);
\echo '@ sel=0.04 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 357);
\echo '@ sel=0.04 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 357);

\echo '@ sel=0.05 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1262);
\echo '@ sel=0.05 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1262);
\echo '@ sel=0.05 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1262);

\echo '@ sel=0.10 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1784);
\echo '@ sel=0.10 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1784);
\echo '@ sel=0.10 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1784);

\echo '@ sel=0.20 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 2523);
\echo '@ sel=0.20 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 2523);
\echo '@ sel=0.20 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 2523);

\echo '@ sel=0.50 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 3989);
\echo '@ sel=0.50 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 3989);
\echo '@ sel=0.50 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 3989);

\echo '@ sel=1.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 5642);
\echo '@ sel=1.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 5642);
\echo '@ sel=1.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 5642);

\echo '@ sel=2.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 7979);
\echo '@ sel=2.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 7979);
\echo '@ sel=2.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 7979);

\echo '@ sel=5.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 12616);
\echo '@ sel=5.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 12616);
\echo '@ sel=5.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 12616);

\echo '@ sel=10.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 17841);
\echo '@ sel=10.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 17841);
\echo '@ sel=10.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 17841);

\echo '@ sel=20.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 25231);
\echo '@ sel=20.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 25231);
\echo '@ sel=20.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 25231);

\echo '@ sel=25.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 28209);
\echo '@ sel=25.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 28209);
\echo '@ sel=25.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 28209);

\echo '@ sel=30.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 30902);
\echo '@ sel=30.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 30902);
\echo '@ sel=30.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 30902);

\echo '@ sel=35.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 33377);
\echo '@ sel=35.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 33377);
\echo '@ sel=35.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 33377);

\echo '@ sel=40.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 35682);
\echo '@ sel=40.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 35682);
\echo '@ sel=40.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 35682);

\echo '@ sel=50.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 39894);
\echo '@ sel=50.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 39894);
\echo '@ sel=50.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 39894);

\echo '@ sel=60.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 43702);
\echo '@ sel=60.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 43702);
\echo '@ sel=60.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 43702);

\echo '@ sel=70.00 mode=planner'
RESET enable_seqscan; RESET enable_indexscan; RESET enable_bitmapscan;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 47203);
\echo '@ sel=70.00 mode=forced_index'
SET enable_seqscan = off; SET enable_bitmapscan = off; SET enable_indexscan = on;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 47203);
\echo '@ sel=70.00 mode=forced_seq'
SET enable_seqscan = on; SET enable_bitmapscan = off; SET enable_indexscan = off;
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 47203);

RESET enable_seqscan;
RESET enable_indexscan;
RESET enable_bitmapscan;
