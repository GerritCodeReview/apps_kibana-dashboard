# Copyright (C) 2019 GerritForge Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

RESTORER_IMG = kibana-dashboard-importer
DUMPER_IMG = taskrabbit/elasticsearch-dump

ELASTICSEARCH_URL=http://host.docker.internal
ELASTICSEARCH_PORT=9200
NAMESPACE=""

.PHONY: build restore

build:
	docker build --no-cache -t $(RESTORER_IMG) .
restore: build
	docker run --rm -it \
		-e ELASTICSEARCH_URL=$(ELASTICSEARCH_URL) \
		-e ELASTICSEARCH_PORT=$(ELASTICSEARCH_PORT) \
		-e NAMESPACE=$(NAMESPACE) \
		$(RESTORER_IMG)
dump: build
	docker run --rm -it \
	        -e ELASTICSEARCH_URL=$(ELASTICSEARCH_URL) \
		-e ELASTICSEARCH_PORT=$(ELASTICSEARCH_PORT) \
		-e NAMESPACE=$(NAMESPACE) \
                $(DUMPER_IMG) \
		--input='$(ELASTICSEARCH_URL):$(ELASTICSEARCH_PORT)/.kibana$(NAMESPACE)' \
		--output=$$ \
		--type=data \
	> ./kibana-config/analytics-settings-dashboards-visualizations.data.json
