\set rows :rows
\echo '== Rebuild spatial test table at' :rows 'rows =='
DROP TABLE IF EXISTS points_1m;

CREATE TABLE points_1m (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  geom geometry(Point, 3857) NOT NULL
);

INSERT INTO points_1m (geom)
SELECT ST_SetSRID(ST_MakePoint((random() - 0.5) * 100000, (random() - 0.5) * 100000), 3857)
FROM generate_series(1, :rows::int);

CREATE INDEX points_1m_geom_gix ON points_1m USING gist (geom);
VACUUM ANALYZE points_1m;

\echo '== Validate row count and index =='
SELECT count(*) AS rows_in_points_1m FROM points_1m;

SELECT
  pg_size_pretty(pg_relation_size('points_1m')) AS heap_size,
  pg_size_pretty(pg_indexes_size('points_1m')) AS indexes_size,
  pg_size_pretty(pg_total_relation_size('points_1m')) AS total_size;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'points_1m'
ORDER BY 1;
