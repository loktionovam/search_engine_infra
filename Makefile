DOCKER_REGISTRY_USER ?= loktionovam

#PROMETHEUS_DOCKER_DIR ?= monitoring/prometheus
#PROMETHEUS_DOCKER_IMAGE_NAME ?= prometheus
#PROMETHEUS_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(PROMETHEUS_DOCKER_DIR)/Dockerfile)
#PROMETHEUS_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(PROMETHEUS_DOCKER_IMAGE_NAME):$(PROMETHEUS_DOCKER_IMAGE_TAG)

#MONGODB_EXPORTER_DOCKER_DIR ?= monitoring/prometheus/mongodb_exporter
#MONGODB_EXPORTER_DOCKER_IMAGE_NAME ?= mongodb_exporter
#MONGODB_EXPORTER_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(MONGODB_EXPORTER_DOCKER_DIR)/Dockerfile)
#MONGODB_EXPORTER_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(MONGODB_EXPORTER_DOCKER_IMAGE_NAME):$(MONGODB_EXPORTER_DOCKER_IMAGE_TAG)

#BLACKBOX_EXPORTER_DOCKER_DIR ?= monitoring/prometheus/blackbox_exporter
#BLACKBOX_EXPORTER_DOCKER_IMAGE_NAME ?= blackbox_exporter
#BLACKBOX_EXPORTER_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(BLACKBOX_EXPORTER_DOCKER_DIR)/Dockerfile)
#BLACKBOX_EXPORTER_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(BLACKBOX_EXPORTER_DOCKER_IMAGE_NAME):$(BLACKBOX_EXPORTER_DOCKER_IMAGE_TAG)

#ALERTMANAGER_DOCKER_DIR ?= monitoring/alertmanager
#ALERTMANAGER_DOCKER_IMAGE_NAME ?= alertmanager
#ALERTMANAGER_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(ALERTMANAGER_DOCKER_DIR)/Dockerfile)
#ALERTMANAGER_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(ALERTMANAGER_DOCKER_IMAGE_NAME):$(ALERTMANAGER_DOCKER_IMAGE_TAG)

#TELEGRAF_DOCKER_DIR ?= monitoring/telegraf
#TELEGRAF_DOCKER_IMAGE_NAME ?= telegraf
#TELEGRAF_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(TELEGRAF_DOCKER_DIR)/Dockerfile)
#TELEGRAF_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(TELEGRAF_DOCKER_IMAGE_NAME):$(TELEGRAF_DOCKER_IMAGE_TAG)

#GRAFANA_DOCKER_DIR ?= monitoring/grafana
#GRAFANA_DOCKER_IMAGE_NAME ?= grafana
#GRAFANA_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(GRAFANA_DOCKER_DIR)/Dockerfile)
#GRAFANA_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(GRAFANA_DOCKER_IMAGE_NAME):$(GRAFANA_DOCKER_IMAGE_TAG)

#STACKDRIVER_DOCKER_DIR ?= monitoring/stackdriver
#STACKDRIVER_DOCKER_IMAGE_NAME ?= stackdriver-exporter
#STACKDRIVER_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(STACKDRIVER_DOCKER_DIR)/Dockerfile)
#STACKDRIVER_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(STACKDRIVER_DOCKER_IMAGE_NAME):$(STACKDRIVER_DOCKER_IMAGE_TAG)

#AUTOHEAL_DOCKER_DIR ?= monitoring/autoheal
#AUTOHEAL_DOCKER_IMAGE_NAME ?= autoheal
#AUTOHEAL_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(AUTOHEAL_DOCKER_DIR)/Dockerfile)
#AUTOHEAL_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(AUTOHEAL_DOCKER_IMAGE_NAME):$(AUTOHEAL_DOCKER_IMAGE_TAG)
#
#FLUENTD_DOCKER_DIR ?= logging/fluentd
#FLUENTD_DOCKER_IMAGE_NAME ?= fluentd
#FLUENTD_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(FLUENTD_DOCKER_DIR)/Dockerfile)
#FLUENTD_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(FLUENTD_DOCKER_IMAGE_NAME):$(FLUENTD_DOCKER_IMAGE_TAG)

SEARCH_ENGINE_CRAWLER_DOCKER_DIR ?= src/search_engine_crawler
SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE_NAME ?= search_engine_crawler
SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(SEARCH_ENGINE_CRAWLER_DOCKER_DIR)/Dockerfile)
SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE_NAME):$(SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE_TAG)

SEARCH_ENGINE_UI_DOCKER_DIR ?= src/search_engine_ui
SEARCH_ENGINE_UI_DOCKER_IMAGE_NAME ?= search_engine_ui
SEARCH_ENGINE_UI_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(SEARCH_ENGINE_UI_DOCKER_DIR)/Dockerfile)
SEARCH_ENGINE_UI_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(SEARCH_ENGINE_UI_DOCKER_IMAGE_NAME):$(SEARCH_ENGINE_UI_DOCKER_IMAGE_TAG)

SEARCH_ENGINE_RABBITMQ_DOCKER_DIR ?= src/search_engine_rabbitmq
SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_NAME ?= search_engine_rabbitmq
SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(SEARCH_ENGINE_RABBITMQ_DOCKER_DIR)/Dockerfile)
SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_NAME):$(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_TAG)

build_search_engine: search_engine_ui_build search_engine_crawler_build search_engine_rabbitmq_build
#build_monitoring: prometheus_build mongodb_exporter_build blackbox_exporter_build alertmanager_build telegraf_build grafana_build stackdriver_build autoheal_build
#build_logging: fluentd_build
build: build_search_engine
#build_monitoring build_logging

push_search_engine: search_engine_ui_push search_engine_crawler_push search_engine_rabbitmq_push
#push_monitoring: prometheus_push mongodb_exporter_push blackbox_exporter_push alermanager_push telegraf_push grafana_push stackdriver_push autoheal_build
#push_logging: fluentd_push
push: push_search_engine
#push_monitoring push_logging

all: build push

search_engine_ui_build:
	@echo ">> building docker image $(SEARCH_ENGINE_UI_DOCKER_IMAGE)"
	@cd "$(SEARCH_ENGINE_UI_DOCKER_DIR)"; \
	echo `git show --format="%h" HEAD | head -1` > build_info.txt; \
	echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt; \
	docker build -t $(SEARCH_ENGINE_UI_DOCKER_IMAGE) .

search_engine_ui_push:
	@echo ">> push $(SEARCH_ENGINE_UI_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(SEARCH_ENGINE_UI_DOCKER_IMAGE)"

search_engine_ui: search_engine_ui_build search_engine_ui_push

search_engine_crawler_build:
	@echo ">> building docker image $(SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE)"
	@cd "$(SEARCH_ENGINE_CRAWLER_DOCKER_DIR)"; \
	echo `git show --format="%h" HEAD | head -1` > build_info.txt; \
	echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt; \
	docker build -t $(SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE) .

search_engine_crawler_push:
	@echo ">> push $(SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(SEARCH_ENGINE_CRAWLER_DOCKER_IMAGE)"

search_engine_crawler: search_engine_crawler_build search_engine_crawler_push

search_engine_rabbitmq_build:
	@echo ">> building docker image $(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE)"
	@cd "$(SEARCH_ENGINE_RABBITMQ_DOCKER_DIR)"; \
	docker build -t $(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE) .

search_engine_rabbitmq_push:
	@echo ">> push $(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE)"

search_engine_rabbitmq: search_engine_rabbitmq_build search_engine_rabbitmq_push

#prometheus_build:
#	@echo ">> building docker image $(PROMETHEUS_DOCKER_IMAGE)"
#	@cd "$(PROMETHEUS_DOCKER_DIR)"; \
#	docker build -t $(PROMETHEUS_DOCKER_IMAGE) .
#
#prometheus_push:
#	@echo ">> push $(PROMETHEUS_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(PROMETHEUS_DOCKER_IMAGE)"
#
#prometheus: prometheus_build prometheus_push
#
#mongodb_exporter_build:
#	@echo ">> building docker image $(MONGODB_EXPORTER_DOCKER_IMAGE)"
#	@cd "$(MONGODB_EXPORTER_DOCKER_DIR)"; \
#	docker build -t $(MONGODB_EXPORTER_DOCKER_IMAGE) .
#
#mongodb_exporter_push:
#	@echo ">> push $(MONGODB_EXPORTER_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(MONGODB_EXPORTER_DOCKER_IMAGE)"
#
#mongodb_exporter: mongodb_exporter_build mongodb_exporter_push
#
#blackbox_exporter_build:
#	@echo ">> building docker image $(BLACKBOX_EXPORTER_DOCKER_IMAGE)"
#	@cd "$(BLACKBOX_EXPORTER_DOCKER_DIR)"; \
#	docker build -t $(BLACKBOX_EXPORTER_DOCKER_IMAGE) .
#
#blackbox_exporter_push:
#	@echo ">> push $(BLACKBOX_EXPORTER_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(BLACKBOX_EXPORTER_DOCKER_IMAGE)"
#
#blackbox_exporter: blackbox_exporter_build blackbox_exporter_push
#
#alertmanager_build:
#	@echo ">> building docker image $(ALERTMANAGER_DOCKER_IMAGE)"
#	@cd "$(ALERTMANAGER_DOCKER_DIR)"; \
#	docker build -t $(ALERTMANAGER_DOCKER_IMAGE) .
#
#alermanager_push:
#	@echo ">> push $(ALERTMANAGER_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(ALERTMANAGER_DOCKER_IMAGE)"
#
#alertmanager: alertmanager_build alermanager_push
#
#telegraf_build:
#	@echo ">> building docker image $(TELEGRAF_DOCKER_IMAGE)"
#	@cd "$(TELEGRAF_DOCKER_DIR)"; \
#	docker build -t $(TELEGRAF_DOCKER_IMAGE) .
#
#telegraf_push:
#	@echo ">> push $(TELEGRAF_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(TELEGRAF_DOCKER_IMAGE)"
#
#telegraf: telegraf_build telegraf_push
#
#grafana_build:
#	@echo ">> building docker image $(GRAFANA_DOCKER_IMAGE)"
#	@cd "$(GRAFANA_DOCKER_DIR)"; \
#	docker build -t $(GRAFANA_DOCKER_IMAGE) .
#
#grafana_push:
#	@echo ">> push $(GRAFANA_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(GRAFANA_DOCKER_IMAGE)"
#
#grafana: grafana_build grafana_push
#
#stackdriver_build:
#	@echo ">> building docker image $(STACKDRIVER_DOCKER_IMAGE)"
#	@cd "$(STACKDRIVER_DOCKER_DIR)"; \
#	docker build -t $(STACKDRIVER_DOCKER_IMAGE) .
#
#stackdriver_push:
#	@echo ">> push $(STACKDRIVER_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(STACKDRIVER_DOCKER_IMAGE)"
#
#stackdriver: stackdriver_build stackdriver_push
#
#autoheal_build:
#	@echo ">> building docker image $(AUTOHEAL_DOCKER_IMAGE)"
#	@cd "$(AUTOHEAL_DOCKER_DIR)"; \
#	docker build -t $(AUTOHEAL_DOCKER_IMAGE) .
#
#autoheal_push:
#	@echo ">> push $(AUTOHEAL_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(AUTOHEAL_DOCKER_IMAGE)"
#
#autoheal: autoheal_build autoheal_push
#
#fluentd_build:
#	@echo ">> building docker image $(FLUENTD_DOCKER_IMAGE)"
#	@cd "$(FLUENTD_DOCKER_DIR)"; \
#	docker build -t $(FLUENTD_DOCKER_IMAGE) .
#
#fluentd_push:
#	@echo ">> push $(FLUENTD_DOCKER_IMAGE) docker image to dockerhub"
#	@docker push "$(FLUENTD_DOCKER_IMAGE)"
#
#fluentd: fluentd_build fluentd_push

run_search_engine:
	@echo ">> Create and start microservices via docker compose"
	@cd docker; docker-compose up -d

up_search_engine: build_search_engine run_search_engine

#run_monitoring:
#	@echo ">> Create and start monitoring microservices via docker compose"
#	@cd docker; docker-compose -f docker-compose-monitoring.yml up -d

#up_monitoring: build_monitoring run_monitoring

#run_logging:
#	@echo ">> Create and start logging microservices via docker compose"
#	@cd docker; docker-compose -f docker-compose-logging.yml up -d

#up_logging: build_logging run_logging

down_search_engine:
	@echo ">> Stop and remove containers, networks, images, and volumes via docker compose"
	@cd docker; docker-compose down

#down_monitoring:
#	@echo ">> Stop and remove containers monitoring via docker compose"
#	@cd docker; docker-compose -f docker-compose-monitoring.yml down
#
#down_logging:
#	@echo ">> Stop and remove containers logging via docker compose"
#	@cd docker; docker-compose -f docker-compose-logging.yml down

up: up_search_engine
#up_logging up_reddit up_monitoring

run: run_search_engine
#run_logging run_reddit run_monitoring

down: down_search_engine
#down_monitoring down_reddit down_logging

.PHONY: all build push up down \
up_search_engine \
down_search_engine \
build_search_engine \
run_search_engine \
search_engine_ui_build search_engine_ui_push search_engine_ui \
search_engine_crawler_build search_engine_crawler_push search_engine_crawler \
search_engine_rabbitmq_build search_engine_rabbitmq_push search_engine_rabbitmq

#.PHONY: all build push up down \
#up_monitoring up_reddit up_logging \
#down_monitoring down_reddit down_logging \
#build_reddit build_monitoring build_logging\
#run_reddit run_monitoring run \
#ui_build ui_push ui \
#post_build post_push post \
#comment_build comment_push comment \
#prometheus prometheus_build prometheus_push \
#mongodb_exporter_build mongodb_exporter_push mongodb_exporter \
#blackbox_exporter blackbox_exporter_build blackbox_exporter_push \
#alertmanager alertmanager_build alermanager_push \
#telegraf telegraf_build telegraf_push \
#grafana grafana_build grafana_push \
#stackdriver stackdriver_build stackdriver_push \
#autoheal autoheal_build autoheal_push \
#fluentd fluentd_build fluentd_push \
#
