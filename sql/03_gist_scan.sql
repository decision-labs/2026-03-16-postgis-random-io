\echo '== Representative ST_DWithin plan (force seqscan off) =='
SET enable_seqscan = off;
SET effective_cache_size = '128MB';

SHOW enable_seqscan;
SHOW effective_cache_size;

EXPLAIN (ANALYZE, TIMING OFF, BUFFERS)
SELECT count(*)
FROM points_1m
WHERE ST_DWithin(
  geom,
  ST_SetSRID(ST_MakePoint(0, 0), 3857),
  400
);
