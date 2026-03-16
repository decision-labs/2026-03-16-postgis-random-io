\echo '== ST_Intersects envelope selectivity sweep at current random_page_cost =='
SHOW random_page_cost;
RESET enable_seqscan;
RESET effective_cache_size;

\echo '-- h=1118  (~0.05%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1118, -1118, 1118, 1118, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1118, -1118, 1118, 1118, 3857));
\echo '-- h=1581  (~0.1%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-1581, -1581, 1581, 1581, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-1581, -1581, 1581, 1581, 3857));
\echo '-- h=2236  (~0.2%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-2236, -2236, 2236, 2236, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-2236, -2236, 2236, 2236, 3857));
\echo '-- h=3536  (~0.5%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-3536, -3536, 3536, 3536, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-3536, -3536, 3536, 3536, 3857));
\echo '-- h=5000  (~1%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-5000, -5000, 5000, 5000, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-5000, -5000, 5000, 5000, 3857));
\echo '-- h=7071  (~2%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-7071, -7071, 7071, 7071, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-7071, -7071, 7071, 7071, 3857));
\echo '-- h=11180 (~5%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-11180, -11180, 11180, 11180, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-11180, -11180, 11180, 11180, 3857));
\echo '-- h=15811 (~10%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-15811, -15811, 15811, 15811, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-15811, -15811, 15811, 15811, 3857));
\echo '-- h=22361 (~20%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-22361, -22361, 22361, 22361, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-22361, -22361, 22361, 22361, 3857));
\echo '-- h=25000 (~25%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE geom && ST_MakeEnvelope(-25000, -25000, 25000, 25000, 3857) AND ST_Intersects(geom, ST_MakeEnvelope(-25000, -25000, 25000, 25000, 3857));
