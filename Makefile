DOCKER_REGISTRY_USER ?= loktionovam

PROMETHEUS_DOCKER_DIR ?= monitoring/prometheus
PROMETHEUS_DOCKER_IMAGE_NAME ?= prometheus
PROMETHEUS_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(PROMETHEUS_DOCKER_DIR)/Dockerfile)
PROMETHEUS_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(PROMETHEUS_DOCKER_IMAGE_NAME):$(PROMETHEUS_DOCKER_IMAGE_TAG)

MONGODB_EXPORTER_DOCKER_DIR ?= monitoring/prometheus/mongodb_exporter
MONGODB_EXPORTER_DOCKER_IMAGE_NAME ?= mongodb_exporter
MONGODB_EXPORTER_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(MONGODB_EXPORTER_DOCKER_DIR)/Dockerfile)
MONGODB_EXPORTER_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(MONGODB_EXPORTER_DOCKER_IMAGE_NAME):$(MONGODB_EXPORTER_DOCKER_IMAGE_TAG)

ALERTMANAGER_DOCKER_DIR ?= monitoring/alertmanager
ALERTMANAGER_DOCKER_IMAGE_NAME ?= alertmanager
ALERTMANAGER_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(ALERTMANAGER_DOCKER_DIR)/Dockerfile)
ALERTMANAGER_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(ALERTMANAGER_DOCKER_IMAGE_NAME):$(ALERTMANAGER_DOCKER_IMAGE_TAG)

GRAFANA_DOCKER_DIR ?= monitoring/grafana
GRAFANA_DOCKER_IMAGE_NAME ?= grafana
GRAFANA_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(GRAFANA_DOCKER_DIR)/Dockerfile)
GRAFANA_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(GRAFANA_DOCKER_IMAGE_NAME):$(GRAFANA_DOCKER_IMAGE_TAG)

FLUENTD_DOCKER_DIR ?= logging/fluentd
FLUENTD_DOCKER_IMAGE_NAME ?= fluentd
FLUENTD_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(FLUENTD_DOCKER_DIR)/Dockerfile)
FLUENTD_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(FLUENTD_DOCKER_IMAGE_NAME):$(FLUENTD_DOCKER_IMAGE_TAG)

SEARCH_ENGINE_CRAWLER_DOCKER_DIR ?= src/search_engine_crawler

SEARCH_ENGINE_UI_DOCKER_DIR ?= src/search_engine_ui

SEARCH_ENGINE_RABBITMQ_DOCKER_DIR ?= src/search_engine_rabbitmq
SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_NAME ?= search_engine_rabbitmq
SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_TAG ?= $(shell ./get_dockerfile_version.sh $(SEARCH_ENGINE_RABBITMQ_DOCKER_DIR)/Dockerfile)
SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE ?= $(DOCKER_REGISTRY_USER)/$(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_NAME):$(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE_TAG)

build_search_engine: search_engine_ui_build search_engine_crawler_build search_engine_rabbitmq_build
build_monitoring: prometheus_build mongodb_exporter_build alertmanager_build grafana_build
build_logging: fluentd_build
build: build_search_engine build_monitoring build_logging

push_search_engine: search_engine_ui_push search_engine_crawler_push search_engine_rabbitmq_push
push_monitoring: prometheus_push mongodb_exporter_push alermanager_push grafana_push
push_logging: fluentd_push
push: push_search_engine push_monitoring push_logging

all: build push

search_engine_ui_build:
	$(MAKE) -C $(SEARCH_ENGINE_UI_DOCKER_DIR) build

search_engine_ui_push:
	$(MAKE) -C $(SEARCH_ENGINE_UI_DOCKER_DIR) push

search_engine_ui: search_engine_ui_build search_engine_ui_push

search_engine_crawler_build:
	$(MAKE) -C $(SEARCH_ENGINE_CRAWLER_DOCKER_DIR) build

search_engine_crawler_push:
	$(MAKE) -C $(SEARCH_ENGINE_CRAWLER_DOCKER_DIR) push

search_engine_crawler: search_engine_crawler_build search_engine_crawler_push

search_engine_rabbitmq_build:
	@echo ">> building docker image $(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE)"
	@cd "$(SEARCH_ENGINE_RABBITMQ_DOCKER_DIR)"; \
	docker build -t $(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE) .

search_engine_rabbitmq_push:
	@echo ">> push $(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(SEARCH_ENGINE_RABBITMQ_DOCKER_IMAGE)"

search_engine_rabbitmq: search_engine_rabbitmq_build search_engine_rabbitmq_push

prometheus_build:
	@echo ">> building docker image $(PROMETHEUS_DOCKER_IMAGE)"
	@cd "$(PROMETHEUS_DOCKER_DIR)"; \
	docker build -t $(PROMETHEUS_DOCKER_IMAGE) .

prometheus_push:
	@echo ">> push $(PROMETHEUS_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(PROMETHEUS_DOCKER_IMAGE)"

prometheus: prometheus_build prometheus_push

mongodb_exporter_build:
	@echo ">> building docker image $(MONGODB_EXPORTER_DOCKER_IMAGE)"
	@cd "$(MONGODB_EXPORTER_DOCKER_DIR)"; \
	docker build -t $(MONGODB_EXPORTER_DOCKER_IMAGE) .

mongodb_exporter_push:
	@echo ">> push $(MONGODB_EXPORTER_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(MONGODB_EXPORTER_DOCKER_IMAGE)"

mongodb_exporter: mongodb_exporter_build mongodb_exporter_push

alertmanager_build:
	@echo ">> building docker image $(ALERTMANAGER_DOCKER_IMAGE)"
	@cd "$(ALERTMANAGER_DOCKER_DIR)"; \
	docker build -t $(ALERTMANAGER_DOCKER_IMAGE) .

alermanager_push:
	@echo ">> push $(ALERTMANAGER_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(ALERTMANAGER_DOCKER_IMAGE)"

alertmanager: alertmanager_build alermanager_push

grafana_build:
	@echo ">> building docker image $(GRAFANA_DOCKER_IMAGE)"
	@cd "$(GRAFANA_DOCKER_DIR)"; \
	docker build -t $(GRAFANA_DOCKER_IMAGE) .

grafana_push:
	@echo ">> push $(GRAFANA_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(GRAFANA_DOCKER_IMAGE)"

grafana: grafana_build grafana_push

fluentd_build:
	@echo ">> building docker image $(FLUENTD_DOCKER_IMAGE)"
	@cd "$(FLUENTD_DOCKER_DIR)"; \
	docker build -t $(FLUENTD_DOCKER_IMAGE) .

fluentd_push:
	@echo ">> push $(FLUENTD_DOCKER_IMAGE) docker image to dockerhub"
	@docker push "$(FLUENTD_DOCKER_IMAGE)"

fluentd: fluentd_build fluentd_push

run_search_engine:
	@echo ">> Create and start microservices via docker compose"
	@cd docker; docker-compose up -d

up_search_engine: build_search_engine run_search_engine

run_monitoring:
	@echo ">> Create and start monitoring microservices via docker compose"
	@cd docker; docker-compose -f docker-compose-monitoring.yml up -d

up_monitoring: build_monitoring run_monitoring

run_logging:
	@echo ">> Create and start logging microservices via docker compose"
	@cd docker; docker-compose -f docker-compose-logging.yml up -d

up_logging: build_logging run_logging

down_search_engine:
	@echo ">> Stop and remove containers, networks, images, and volumes via docker compose"
	@cd docker; docker-compose down

down_monitoring:
	@echo ">> Stop and remove containers monitoring via docker compose"
	@cd docker; docker-compose -f docker-compose-monitoring.yml down

down_logging:
	@echo ">> Stop and remove containers logging via docker compose"
	@cd docker; docker-compose -f docker-compose-logging.yml down

up: up_search_engine up_monitoring up_logging

run: run_search_engine run_monitoring run_logging

down: down_monitoring down_search_engine down_logging

.PHONY: all build push up down run\
up_monitoring up_search_engine up_logging \
down_monitoring down_search_engine down_logging \
build_monitoring build_search_engine build_logging \
run_monitoring run_search_engine run_logging \
search_engine_ui search_engine_ui_build search_engine_ui_push \
search_engine_crawler search_engine_crawler_build search_engine_crawler_push \
search_engine_rabbitmq search_engine_rabbitmq_build search_engine_rabbitmq_push \
prometheus prometheus_build prometheus_push \
mongodb_exporter mongodb_exporter_build mongodb_exporter_push \
alertmanager alertmanager_build alermanager_push \
grafana grafana_build grafana_push \
fluentd fluentd_build fluentd_push
