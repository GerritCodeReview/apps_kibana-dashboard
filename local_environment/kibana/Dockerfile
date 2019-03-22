FROM docker.elastic.co/kibana/kibana:6.5.4

env XPACK_ML_ENABLED=false
env XPACK_APM_ENABLED=false
env XPACK_APM_UI_ENABLED=false
env XPACK_GRAPH_ENABLED=false
env XPACK_INFRA_ENABLED=false
env XPACK_MONITORING_ENABLED=false
env XPACK_REPORTING_ENABLED=false

RUN /usr/local/bin/kibana-docker --optimize
