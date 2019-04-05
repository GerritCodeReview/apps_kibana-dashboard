# Local environment

this project provides a docker-compose to facilitate spinning of a local environment running kibana and elasticsearch.

## Getting Started

To get you running in no time, this project also provides a way to spin up a local environment with elasticsearch and kibana:

```bash
cd local_environment
docker-compose up
```

this will start:
* elasticsearch, bound and exposing port 9200 and 9300
* kibana, bound and exposing port 5601

and will also configure the dashboard for you so that you already have all the mappings, the kibana settigs and the main
visualizations and dashboard already configured.

### Multiple dashboards environment

If you want to spin up an environment in which you have multiple kibana dashboards configured,
you ca run the following:

```bash
cd local_environmet
docker-compose -f docker-compose.multi-dashboard.yaml up
```

### Build kibana for local environment

The docker-compose relies on an external image (```gerritforge/analytics-kibana-6.5.4``), which is also maintained
as part of this repository.
If you don't need to make any changes to it you can just spin up the docker-compose, however if you want to build a
new version you must follow these steps:

* you must have an instance of elasticsearch running (this is needed by the kibana optimization step),
if you don't you can use the docker-compose one:

```bash
cd local_environment
docker-compose up elasticsearch
```

* Make the relevant changes to the kibana `Dockerfile`

```bash
cd local_environment/kibana
# ... make changes ...
docker build --network=local_environment_analytics -t gerritforge/analytics-kibana-6.5.4 .
```