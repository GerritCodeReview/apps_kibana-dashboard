#!/bin/sh

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

/wait-for-elasticsearch

ES_URL="$ELASTICSEARCH_URL:$ELASTICSEARCH_PORT"

echo "* * * * Create elasticsearch indexes @ $ES_URL * * * *"
for file in `ls -v /elasticsearch-config/*.json`; do
	echo "--> $file";

	index_template_name=$(basename $file .json)$NAMESPACE
	index_name="${index_template_name}_initial"

	echo "* * * Creating $index_template_name index template"
	curl -X PUT -v -H 'Content-Type: application/json' -d @${file} ${ES_URL}/_template/${index_template_name}

	echo "* * * * Creating $index_name index * * * *"
	curl -XPUT "$ES_URL/$index_name?pretty" -H 'Content-Type: application/json'

    echo "* * * * Creating alias $index_template_name -> $index_name index * * * *"
    curl -XPOST "$ES_URL/_aliases" -H 'Content-Type: application/json' -d"{\"actions\" : [
            { \"add\" : { \"index\" : \"$index_name\", \"alias\" : \"$index_template_name\" } }
        ]
    }"

done;

echo "* * * * Input kibana settings and visualizations @ $ES_URL [.kibana$NAMESPACE] * * * *"
for file in `ls -v /kibana-config/*.data.json`; do
       echo "--> $file";
        /usr/lib/node_modules/elasticdump/bin/elasticdump \
		--output=$ES_URL/.kibana$NAMESPACE \
            --input=$file \
            --type=data \
            --headers '{"Content-Type": "application/json"}';
        echo "Done with $file";
done;
