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
for template_file in `ls -v /elasticsearch-config/*.json`; do
	echo "--> $template_file";

    index_template=$(basename $template_file .json)

	namespaced_index_name=${index_template}${NAMESPACE}
	namespaced_initial_index_name="${namespaced_index_name}_initial"

	echo "* * * Creating $index_template index template"
	curl -X PUT -v -H 'Content-Type: application/json' -d @${template_file} ${ES_URL}/_template/${index_template}

	echo "* * * * Creating $namespaced_initial_index_name index * * * *"
	curl -XPUT "$ES_URL/$namespaced_initial_index_name?pretty" -H 'Content-Type: application/json'

    echo "* * * * Creating alias $namespaced_index_name -> $namespaced_initial_index_name index * * * *"
    curl -XPOST "$ES_URL/_aliases" -H 'Content-Type: application/json' -d"{\"actions\" : [
            { \"add\" : { \"index\" : \"$namespaced_initial_index_name\", \"alias\" : \"$namespaced_index_name\" } }
        ]
    }"

done;

echo "* * * * Input kibana settings and visualizations @ $ES_URL [.kibana] * * * *"
for template_file in `ls -v /kibana-config/*.template.json`; do
       target=$(mktemp /tmp/kibana-config.XXXXXX);

       echo "* * * * compiling $template_file into $target";
       envsubst < ${template_file} > ${target};

        /usr/lib/node_modules/elasticdump/bin/elasticdump \
            --output=${ES_URL}/.kibana \
            --input=${target} \
            --type=data \
            --headers '{"Content-Type": "application/json"}';
        echo "Done with $template_file";
done;