DB ?= spatial_rpc_lab
PSQL ?= psql
RPC ?= 30
RESULTS_DIR ?= results
GRAPH_FILE ?= $(RESULTS_DIR)/spatial_random_io_sweep.png
INTERSECTS_GRAPH_FILE ?= $(RESULTS_DIR)/spatial_intersects_sweep.png
MAP_FILE ?= $(RESULTS_DIR)/spatial_query_map.png
MAP_RADII ?= 1262,5642,12616,17841,25231,28209
MAP_HIT_RADIUS ?= 28209
MAP_HIT_SAMPLE ?= 0.10

.PHONY: help init build seq gist sweep compare graph isweep icompare igraph map all

help:
	@echo "Targets:"
	@echo "  make init    DB=<db_name>        # create DB + enable PostGIS + show baseline settings"
	@echo "  make build   DB=<db_name>        # create 1M-point dataset + GiST index + analyze"
	@echo "  make seq     DB=<db_name>        # run sequential scan baseline"
	@echo "  make gist    DB=<db_name>        # run representative ST_DWithin plan"
	@echo "  make sweep   DB=<db_name>        # run ST_DWithin radius sweep at default rpc"
	@echo "  make compare DB=<db_name> RPC=30 # run ST_DWithin sweep with adjusted rpc"
	@echo "  make graph                       # plot default vs adjusted sweep"
	@echo "  make isweep  DB=<db_name>        # run ST_Intersects envelope sweep at default rpc"
	@echo "  make icompare DB=<db_name> RPC=30# run ST_Intersects sweep with adjusted rpc"
	@echo "  make igraph                      # plot ST_Intersects default vs adjusted sweep"
	@echo "  make map                         # plot area, sample points, and sweep radii"
	@echo "  make all     DB=<db_name>        # init build seq gist sweep"

$(RESULTS_DIR):
	mkdir -p "$(RESULTS_DIR)"

init: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -v db="$(DB)" -d postgres -f sql/00_init_db.sql | tee "$(RESULTS_DIR)/00_init_db.out"

build: | $(RESULTS_DIR)
	$(PSQL) -v ON_ERROR_STOP=1 -d "$(DB)" -f sql/01_build_dataset.sql | tee "$(RESULTS_DIR)/01_build_dataset.out"

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

graph: | $(RESULTS_DIR)
	python3 plot_results.py \
		--default-out "$(RESULTS_DIR)/04_dwithin_sweep.out" \
		--compare-out "$(RESULTS_DIR)/05_compare_rpc.out" \
		--output "$(GRAPH_FILE)"

igraph: | $(RESULTS_DIR)
	python3 plot_intersects.py \
		--default-out "$(RESULTS_DIR)/06_intersects_sweep.out" \
		--compare-out "$(RESULTS_DIR)/07_intersects_compare_rpc.out" \
		--output "$(INTERSECTS_GRAPH_FILE)"

map: | $(RESULTS_DIR)
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m TABLESAMPLE BERNOULLI (0.50);") > "$(RESULTS_DIR)/map_sample_points.csv"
	(echo "x,y"; $(PSQL) -X -q -v ON_ERROR_STOP=1 -d "$(DB)" -At -F, -c "SELECT ST_X(geom), ST_Y(geom) FROM points_1m WHERE ST_DWithin(geom, ST_SetSRID(ST_MakePoint(0,0),3857), $(MAP_HIT_RADIUS)) AND random() < $(MAP_HIT_SAMPLE);") > "$(RESULTS_DIR)/map_query_hits.csv"
	python3 plot_map.py \
		--sample-csv "$(RESULTS_DIR)/map_sample_points.csv" \
		--hits-csv "$(RESULTS_DIR)/map_query_hits.csv" \
		--radii "$(MAP_RADII)" \
		--hit-radius "$(MAP_HIT_RADIUS)" \
		--output "$(MAP_FILE)"

all: init build seq gist sweep
