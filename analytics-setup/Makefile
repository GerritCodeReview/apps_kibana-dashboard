RESTORER_IMG = kibana-dashboard-importer
DUMPER_IMG = taskrabbit/elasticsearch-dump
ELASTICSEARCH_URL=http://host.docker.internal
ELASTICSEARCH_PORT=9200

.PHONY: build restore

build:
	docker build --no-cache -t $(RESTORER_IMG) .
restore: build
	docker run --rm -it \
		-e ELASTICSEARCH_URL=$(ELASTICSEARCH_URL) \
		-e ELASTICSEARCH_PORT=$(ELASTICSEARCH_PORT) \
		$(RESTORER_IMG)
dump: build
	docker run --rm -it \
	        -e ELASTICSEARCH_URL=$(ELASTICSEARCH_URL) \
		-e ELASTICSEARCH_PORT=$(ELASTICSEARCH_PORT) \
                $(DUMPER_IMG) \
		--input='$(ELASTICSEARCH_URL):$(ELASTICSEARCH_PORT)/.kibana' \
		--output=$$ \
		--type=data \
	> ./kibana-config/analytics-settings-dashboards-visualizations.data.json
