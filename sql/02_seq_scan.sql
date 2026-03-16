\echo '== Sequential scan baseline =='
RESET enable_seqscan;
RESET effective_cache_size;

EXPLAIN (ANALYZE, TIMING OFF, BUFFERS)
SELECT * FROM points_1m;
