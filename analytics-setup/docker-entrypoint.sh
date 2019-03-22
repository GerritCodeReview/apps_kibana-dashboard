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

echo "* * * * Create elasticsearch indexes @ $ELASTICSEARCH_URL:$ELASTICSEARCH_PORT * * * *"
for file in `ls -v /elasticsearch-config/*.json`; do
	echo "--> $file";
	index_template_name=$(basename $file .json)
	index_name="${index_template_name}_initial"
	curl -X PUT -v -H 'Content-Type: application/json' \
        -d @$file $ELASTICSEARCH_URL:$ELASTICSEARCH_PORT/_template/$index_template_name

	echo "* * * * Creating $index_name index * * * *"
	curl -XPUT "$ELASTICSEARCH_URL:$ELASTICSEARCH_PORT/$index_name?pretty" -H 'Content-Type: application/json'

    curl -XPOST "$ELASTICSEARCH_URL:$ELASTICSEARCH_PORT/_aliases" -H 'Content-Type: application/json' -d"{\"actions\" : [
            { \"add\" : { \"index\" : \"$index_name\", \"alias\" : \"$index_template_name\" } }
        ]
    }"

done;

echo "* * * * Input kibana settings @ $ELASTICSEARCH_URL:$ELASTICSEARCH_PORT * * * *"
for file in `ls -v /kibana-config/*.data.json`; do
       echo "--> $file";
        /usr/lib/node_modules/elasticdump/bin/elasticdump \
            --output=$ELASTICSEARCH_URL:$ELASTICSEARCH_PORT/.kibana \
            --input=$file \
            --type=data \
            --headers '{"Content-Type": "application/json"}';
done;
