\echo '== ST_DWithin selectivity sweep with adjusted random_page_cost =='
SET random_page_cost = :rpc;
SHOW random_page_cost;
RESET enable_seqscan;
RESET effective_cache_size;

\echo '-- r=1262  (~0.05%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1262);
\echo '-- r=1784  (~0.1%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 1784);
\echo '-- r=2523  (~0.2%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 2523);
\echo '-- r=3989  (~0.5%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 3989);
\echo '-- r=5642  (~1%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 5642);
\echo '-- r=7979  (~2%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 7979);
\echo '-- r=12616 (~5%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 12616);
\echo '-- r=17841 (~10%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 17841);
\echo '-- r=25231 (~20%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 25231);
\echo '-- r=28209 (~25%)'
EXPLAIN (ANALYZE, TIMING OFF, BUFFERS) SELECT count(*) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), 28209);
