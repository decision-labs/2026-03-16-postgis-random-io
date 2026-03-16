\echo '== Create database if missing =='
SELECT format('CREATE DATABASE %I', :'db')
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = :'db')
\gexec

\echo '== Connect, enable PostGIS, and show baseline settings =='
\c :db

CREATE EXTENSION IF NOT EXISTS postgis;

SELECT PostGIS_Full_Version();

SELECT name, setting, unit
FROM pg_settings
WHERE name IN (
  'shared_buffers',
  'effective_cache_size',
  'random_page_cost',
  'seq_page_cost',
  'effective_io_concurrency'
)
ORDER BY 1;
