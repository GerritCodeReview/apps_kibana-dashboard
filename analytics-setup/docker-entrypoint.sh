#!/bin/sh



/wait-for-elasticsearch

echo "* * * * Create elasticsearch indexes @ $ELASTICSEARCH_URL:$ELASTICSEARCH_PORT * * * *"
for file in `ls -v /elasticsearch-config/*.json`; do
	echo "--> $file";
	index_name=$(basename $file .json)
	curl -X PUT -v -H 'Content-Type: application/json' \
     		-d @$file $ELASTICSEARCH_URL:$ELASTICSEARCH_PORT/_template/$index_name

	echo "* * * * Creating $index_name index * * * *"
	curl -XPUT "$ELASTICSEARCH_URL:$ELASTICSEARCH_PORT/$index_name?pretty" -H 'Content-Type: application/json'
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
