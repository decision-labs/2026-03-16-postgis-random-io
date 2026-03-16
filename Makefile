DB ?= spatial_rpc_lab
PSQL ?= psql
RPC ?= 30
ROWS ?= 1000000
RESULTS_DIR ?= results
GRAPH_FILE ?= $(RESULTS_DIR)/spatial_random_io_sweep.png
GRAPH_DARK_FILE ?= $(RESULTS_DIR)/spatial_random_io_sweep_dark.png
INTERSECTS_GRAPH_FILE ?= $(RESULTS_DIR)/spatial_intersects_sweep.png
INTERSECTS_GRAPH_DARK_FILE ?= $(RESULTS_DIR)/spatial_intersects_sweep_dark.png
DWITHIN_CROSSOVER_FILE ?= $(RESULTS_DIR)/spatial_dwithin_crossover.png
DWITHIN_CROSSOVER_DARK_FILE ?= $(RESULTS_DIR)/spatial_dwithin_crossover_dark.png
INTERSECTS_CROSSOVER_FILE ?= $(RESULTS_DIR)/spatial_intersects_crossover.png
INTERSECTS_CROSSOVER_DARK_FILE ?= $(RESULTS_DIR)/spatial_intersects_crossover_dark.png
MAP_FILE ?= $(RESULTS_DIR)/spatial_query_map.png
MAP_DARK_FILE ?= $(RESULTS_DIR)/spatial_query_map_dark.png
INTERSECTS_MAP_FILE ?= $(RESULTS_DIR)/spatial_intersects_map.png
INTERSECTS_MAP_DARK_FILE ?= $(RESULTS_DIR)/spatial_intersects_map_dark.png
REPEAT_SWEEP_FILE ?= $(RESULTS_DIR)/spatial_random_io_sweep_repeated.png
REPEAT_SWEEP_DARK_FILE ?= $(RESULTS_DIR)/spatial_random_io_sweep_repeated_dark.png
REPEAT_SWEEP_CSV ?= $(RESULTS_DIR)/spatial_random_io_sweep_repeated.csv
REPEAT_INTERSECTS_FILE ?= $(RESULTS_DIR)/spatial_intersects_sweep_repeated.png
REPEAT_INTERSECTS_DARK_FILE ?= $(RESULTS_DIR)/spatial_intersects_sweep_repeated_dark.png
REPEAT_INTERSECTS_CSV ?= $(RESULTS_DIR)/spatial_intersects_sweep_repeated.csv
REPEATS ?= 5
MAP_RADII ?= 1262,5642,12616,17841,25231,28209
MAP_HIT_RADIUS ?= 28209
MAP_HIT_SAMPLE ?= 0.10

.PHONY: help init build seq gist sweep compare graph graph-dark graph-repeated graph-repeated-dark isweep icompare igraph igraph-dark igraph-repeated igraph-repeated-dark dcrossover icrossover dgraph-crossover dgraph-crossover-dark igraph-crossover igraph-crossover-dark map map-dark imap imap-dark all

help:
	@echo "Targets:"
	@echo "  make init    DB=<db_name>        # create DB + enable PostGIS + show baseline settings"
	@echo "  make build   DB=<db_name> ROWS=1000000 # create dataset + GiST index + analyze"
	@echo "  make seq     DB=<db_name>        # run sequential scan baseline"
	@echo "  make gist    DB=<db_name>        # run representative ST_DWithin plan"
	@echo "  make sweep   DB=<db_name>        # run ST_DWithin radius sweep at default rpc"
	@echo "  make compare DB=<db_name> RPC=30 # run ST_DWithin sweep with adjusted rpc"
	@echo "  make graph                       # plot default vs adjusted sweep"
	@echo "  make graph-dark                  # plot dark-mode ST_DWithin sweep"
	@echo "  make graph-repeated              # rerun sweep multiple times, plot median/p95"
	@echo "  make graph-repeated-dark         # dark-mode repeated-run ST_DWithin chart"
	@echo "  make isweep  DB=<db_name>        # run ST_Intersects envelope sweep at default rpc"
	@echo "  make icompare DB=<db_name> RPC=30# run ST_Intersects sweep with adjusted rpc"
	@echo "  make igraph                      # plot ST_Intersects default vs adjusted sweep"
	@echo "  make igraph-dark                 # plot dark-mode ST_Intersects sweep"
	@echo "  make igraph-repeated             # repeat ST_Intersects sweep and plot median/p95"
	@echo "  make igraph-repeated-dark        # dark-mode repeated ST_Intersects chart"
	@echo "  make dcrossover                  # run ST_DWithin planner/forced crossover runs"
	@echo "  make dgraph-crossover            # plot ST_DWithin cost vs runtime crossover"
	@echo "  make icrossover                  # run ST_Intersects planner/forced crossover runs"
	@echo "  make igraph-crossover            # plot ST_Intersects cost vs runtime crossover"
	@echo "  make map                         # plot area, sample points, and sweep radii"
	@echo "  make map-dark                    # plot dark-mode query area map"
	@echo "  make imap                        # plot envelope-based ST_Intersects map"
	@echo "  make imap-dark                   # plot dark-mode ST_Intersects map"
	@echo "  make all     DB=<db_name>        # init build seq gist sweep"

$(RESULTS_DIR):
	mkdir -p "$(RESULTS_DIR)"

init: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -v db="$(DB)" -d postgres -f sql/00_init_db.sql | tee "$(RESULTS_DIR)/00_init_db.out"

build: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -v rows="$(ROWS)" -d "$(DB)" -f sql/01_build_dataset.sql | tee "$(RESULTS_DIR)/01_build_dataset.out"

seq: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -d "$(DB)" -f sql/02_seq_scan.sql | tee "$(RESULTS_DIR)/02_seq_scan.out"

gist: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -d "$(DB)" -f sql/03_gist_scan.sql | tee "$(RESULTS_DIR)/03_gist_scan.out"

sweep: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -d "$(DB)" -f sql/04_dwithin_sweep.sql | tee "$(RESULTS_DIR)/04_dwithin_sweep.out"

compare: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -v rpc="$(RPC)" -d "$(DB)" -f sql/05_compare_rpc.sql | tee "$(RESULTS_DIR)/05_compare_rpc.out"

isweep: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -d "$(DB)" -f sql/06_intersects_sweep.sql | tee "$(RESULTS_DIR)/06_intersects_sweep.out"

icompare: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -v rpc="$(RPC)" -d "$(DB)" -f sql/07_intersects_compare_rpc.sql | tee "$(RESULTS_DIR)/07_intersects_compare_rpc.out"

dcrossover: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -d "$(DB)" -f sql/08_dwithin_crossover.sql | tee "$(RESULTS_DIR)/08_dwithin_crossover.out"

icrossover: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -d "$(DB)" -f sql/09_intersects_crossover.sql | tee "$(RESULTS_DIR)/09_intersects_crossover.out"

graph: | $(RESULTS_DIR)
	python3 plot_results.py \
		--default-out "$(RESULTS_DIR)/04_dwithin_sweep.out" \
		--compare-out "$(RESULTS_DIR)/05_compare_rpc.out" \
		--output "$(GRAPH_FILE)"

graph-dark: | $(RESULTS_DIR)
	python3 plot_results.py \
		--default-out "$(RESULTS_DIR)/04_dwithin_sweep.out" \
		--compare-out "$(RESULTS_DIR)/05_compare_rpc.out" \
		--theme dark \
		--output "$(GRAPH_DARK_FILE)"

graph-repeated: | $(RESULTS_DIR)
	python3 plot_results_repeated.py \
		--psql "$(PSQL)" \
		--db "$(DB)" \
		--repeats "$(REPEATS)" \
		--rpc "$(RPC)" \
		--default-sql "sql/04_dwithin_sweep.sql" \
		--compare-sql "sql/05_compare_rpc.sql" \
		--title "Spatial ST_DWithin Sweep" \
		--xlabel "Radius (meters)" \
		--raw-csv "$(REPEAT_SWEEP_CSV)" \
		--output "$(REPEAT_SWEEP_FILE)"

graph-repeated-dark: | $(RESULTS_DIR)
	python3 plot_results_repeated.py \
		--psql "$(PSQL)" \
		--db "$(DB)" \
		--repeats "$(REPEATS)" \
		--rpc "$(RPC)" \
		--default-sql "sql/04_dwithin_sweep.sql" \
		--compare-sql "sql/05_compare_rpc.sql" \
		--theme dark \
		--title "Spatial ST_DWithin Sweep" \
		--xlabel "Radius (meters)" \
		--raw-csv "$(REPEAT_SWEEP_CSV)" \
		--output "$(REPEAT_SWEEP_DARK_FILE)"

igraph-repeated: | $(RESULTS_DIR)
	python3 plot_results_repeated.py \
		--psql "$(PSQL)" \
		--db "$(DB)" \
		--repeats "$(REPEATS)" \
		--rpc "$(RPC)" \
		--default-sql "sql/06_intersects_sweep.sql" \
		--compare-sql "sql/07_intersects_compare_rpc.sql" \
		--title "Spatial ST_Intersects Sweep" \
		--xlabel "Envelope half-side (meters)" \
		--raw-csv "$(REPEAT_INTERSECTS_CSV)" \
		--output "$(REPEAT_INTERSECTS_FILE)"

igraph-repeated-dark: | $(RESULTS_DIR)
	python3 plot_results_repeated.py \
		--psql "$(PSQL)" \
		--db "$(DB)" \
		--repeats "$(REPEATS)" \
		--rpc "$(RPC)" \
		--default-sql "sql/06_intersects_sweep.sql" \
		--compare-sql "sql/07_intersects_compare_rpc.sql" \
		--theme dark \
		--title "Spatial ST_Intersects Sweep" \
		--xlabel "Envelope half-side (meters)" \
		--raw-csv "$(REPEAT_INTERSECTS_CSV)" \
		--output "$(REPEAT_INTERSECTS_DARK_FILE)"

igraph: | $(RESULTS_DIR)
	python3 plot_intersects.py \
		--default-out "$(RESULTS_DIR)/06_intersects_sweep.out" \
		--compare-out "$(RESULTS_DIR)/07_intersects_compare_rpc.out" \
		--output "$(INTERSECTS_GRAPH_FILE)"

igraph-dark: | $(RESULTS_DIR)
	python3 plot_intersects.py \
		--default-out "$(RESULTS_DIR)/06_intersects_sweep.out" \
		--compare-out "$(RESULTS_DIR)/07_intersects_compare_rpc.out" \
		--theme dark \
		--output "$(INTERSECTS_GRAPH_DARK_FILE)"

dgraph-crossover: | $(RESULTS_DIR)
	python3 plot_spatial_crossover.py \
		--input "$(RESULTS_DIR)/08_dwithin_crossover.out" \
		--xlabel "Selectivity (%)" \
		--title "ST_DWithin: Planner Cost vs Runtime Crossover" \
		--output "$(DWITHIN_CROSSOVER_FILE)"

dgraph-crossover-dark: | $(RESULTS_DIR)
	python3 plot_spatial_crossover.py \
		--input "$(RESULTS_DIR)/08_dwithin_crossover.out" \
		--xlabel "Selectivity (%)" \
		--title "ST_DWithin: Planner Cost vs Runtime Crossover" \
		--theme dark \
		--output "$(DWITHIN_CROSSOVER_DARK_FILE)"

igraph-crossover: | $(RESULTS_DIR)
	python3 plot_spatial_crossover.py \
		--input "$(RESULTS_DIR)/09_intersects_crossover.out" \
		--xlabel "Selectivity (%)" \
		--title "ST_Intersects: Planner Cost vs Runtime Crossover" \
		--output "$(INTERSECTS_CROSSOVER_FILE)"

igraph-crossover-dark: | $(RESULTS_DIR)
	python3 plot_spatial_crossover.py \
		--input "$(RESULTS_DIR)/09_intersects_crossover.out" \
		--xlabel "Selectivity (%)" \
		--title "ST_Intersects: Planner Cost vs Runtime Crossover" \
		--theme dark \
		--output "$(INTERSECTS_CROSSOVER_DARK_FILE)"

map: | $(RESULTS_DIR)
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m TABLESAMPLE BERNOULLI (0.50);") > "$(RESULTS_DIR)/map_sample_points.csv"
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), $(MAP_HIT_RADIUS)) AND random() < $(MAP_HIT_SAMPLE);") > "$(RESULTS_DIR)/map_query_hits.csv"
	python3 plot_map.py \
		--sample-csv "$(RESULTS_DIR)/map_sample_points.csv" \
		--hits-csv "$(RESULTS_DIR)/map_query_hits.csv" \
		--radii "$(MAP_RADII)" \
		--hit-radius "$(MAP_HIT_RADIUS)" \
		--output "$(MAP_FILE)"

map-dark: | $(RESULTS_DIR)
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m TABLESAMPLE BERNOULLI (0.50);") > "$(RESULTS_DIR)/map_sample_points.csv"
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), $(MAP_HIT_RADIUS)) AND random() < $(MAP_HIT_SAMPLE);") > "$(RESULTS_DIR)/map_query_hits.csv"
	python3 plot_map.py \
		--sample-csv "$(RESULTS_DIR)/map_sample_points.csv" \
		--hits-csv "$(RESULTS_DIR)/map_query_hits.csv" \
		--radii "$(MAP_RADII)" \
		--hit-radius "$(MAP_HIT_RADIUS)" \
		--theme dark \
		--output "$(MAP_DARK_FILE)"

imap: | $(RESULTS_DIR)
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m TABLESAMPLE BERNOULLI (0.50);") > "$(RESULTS_DIR)/imap_sample_points.csv"
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m WHERE geom && ST_MakeEnvelope(-25000,-25000,25000,25000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-25000,-25000,25000,25000,3857)) AND random() < 0.10;") > "$(RESULTS_DIR)/imap_query_hits.csv"
	python3 plot_map_intersects.py \
		--sample-csv "$(RESULTS_DIR)/imap_sample_points.csv" \
		--hits-csv "$(RESULTS_DIR)/imap_query_hits.csv" \
		--half-sides "1118,5000,11180,15811,22361,25000" \
		--output "$(INTERSECTS_MAP_FILE)"

imap-dark: | $(RESULTS_DIR)
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m TABLESAMPLE BERNOULLI (0.50);") > "$(RESULTS_DIR)/imap_sample_points.csv"
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m WHERE geom && ST_MakeEnvelope(-25000,-25000,25000,25000,3857) AND ST_Intersects(geom, ST_MakeEnvelope(-25000,-25000,25000,25000,3857)) AND random() < 0.10;") > "$(RESULTS_DIR)/imap_query_hits.csv"
	python3 plot_map_intersects.py \
		--sample-csv "$(RESULTS_DIR)/imap_sample_points.csv" \
		--hits-csv "$(RESULTS_DIR)/imap_query_hits.csv" \
		--half-sides "1118,5000,11180,15811,22361,25000" \
		--theme dark \
		--output "$(INTERSECTS_MAP_DARK_FILE)"

all: init build seq gist sweep
