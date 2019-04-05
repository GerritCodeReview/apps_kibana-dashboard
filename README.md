# Kibana Dashboard

The goal of this project is to provide the tools to manage and configure kibana dashboard(s)
aimed to visualize analytics on project contributions.
Kibana configuration is maintained in elasticsearch so, in reality, this project will talk to the elasticsearch
instance which kibana is connected to.

For the time being, this project allows to configure only one type of dashboard:

* **Git Commits Dashboard**:
which is able to display data produced by the execution of the [GIT commits ETL](https://github.com/GerritCodeReview/apps_analytics-etl#git-commits) analytics ETL
 

## Getting Started

To get you running in no time, this project also provides a way to spin up a local environment with elasticsearch and kibana:

```bash
cd local_environment
docker-compose up

```

this will start:
* elasticsearch, bound and exposing port 9200 and 9300
* kibana, bound and exposing port 5601

and will also configure the dashboard for you so that you already have all the mappings, the kibana settigs and the main visualizations and dashboard already configured.
Just browse to `http://localhost:5601` to see the configured dashboard.

At this point the dashboard will still be empty.
If you want to populate it with data you might want to run the [GIT commits ETL](https://github.com/GerritCodeReview/apps_analytics-etl#git-commits)

### Prerequisites

* [docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)
* [make](https://www.gnu.org/software/make/)

## Restore kibana configuration
To configure a kibana dashboard you can simply point the setup script to the target elasticsearch as follows

```make restore [ELASTICSEARCH_URL] [ELASTICSEARCH_PORT] [NAMESPACE]```

* ELASTICSEARCH_URL: default is `http://host.docker.internal` (the current host running docker)
* ELASTICSEARCH_PORT: default is 9200
* NAMESPACE: default is empty.

#### Namespace
A namespace is a string that will be postifxed to elassticsearch indexes.
This allows to configure multiple kibana instances against the same elasticsearch instance on the same server without collisions.
For example, if you use the namespace _foo_, this will configure in order:

* an elasticsearch index named gitcommitsfoo
* a kibana dashboard named .kibanafoo

## Dump kibana configuration

If you make some changes to kibana and you want to dump them on disk for later use you can
just run:

```make dump [ELASTICSEARCH_URL] [ELASTICSEARCH_PORT] [NAMESPACE]```

* ELASTICSEARCH_URL: default is `http://host.docker.internal` (the current host running docker)
* ELASTICSEARCH_PORT: default is 9200
* NAMESPACE: default is empty string

For example to dump the configuration of kibana spinned up via local environment you can simply run:
```bash
cd analytics-setup
make dump
```

This will save any changes to ```kibana-config/analytics-settings-dashboards-visualizations.data.json```

## License

This project is licensed under the Apache License, Version 2.0 License - see the [LICENSE](LICENSE) file for details
