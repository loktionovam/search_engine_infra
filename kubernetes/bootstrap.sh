#!/usr/bin/env bash
set -x
CLUSTER_NAME=$1
ZONE=$2
PROJECT=$3
EXTERNAL_IP=$4
SCRIPT_DIR=$(dirname $(realpath "$0"))
BOOTSTRAP_DIR="${SCRIPT_DIR}"/bootstrap
CHART_DIR="${SCRIPT_DIR}"/charts
GRAFANA_PASSWD=$(cat /dev/urandom| tr -c -d '[:alnum:]' | head -c 12)
KIBANA_PASSWD=$(cat /dev/urandom| tr -c -d '[:alnum:]' | head -c 12)

gcloud container clusters get-credentials "${CLUSTER_NAME}" --zone "${ZONE}" --project "${PROJECT}"
gcloud beta container clusters update "${CLUSTER_NAME}" --zone "${ZONE}" --monitoring-service none
gcloud beta container clusters update "${CLUSTER_NAME}" --zone "${ZONE}" --logging-service none

kubectl apply -f "${BOOTSTRAP_DIR}"/tiller.yaml
helm init --wait --service-account tiller

helm dependency update "${CHART_DIR}"/search_engine/

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --wait --install gitlab gitlab/gitlab \
  --timeout 600 \
  --values "${CHART_DIR}"/gitlab/values.yaml \
  --set global.hosts.externalIP="${EXTERNAL_IP}"

helm upgrade --wait --install prometheus "${CHART_DIR}"/prometheus \
  --values "${CHART_DIR}"/prometheus/custom_values.yaml

helm dep build "${CHART_DIR}"/grafana

helm upgrade --wait --install grafana "${CHART_DIR}"/grafana \
  --set "grafana.adminPassword=${GRAFANA_PASSWD}" \
  --values "${CHART_DIR}"/grafana/values.yaml

helm dependency update "${CHART_DIR}"/efk

helm upgrade --wait --install logging "${CHART_DIR}"/efk \
  --set "kibana.auth=$(htpasswd -nb admin ${KIBANA_PASSWD} | base64)" \
  --values "${CHART_DIR}"/efk/values.yaml

echo "Gitlab root password: $(kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath={.data.password} | base64 --decode ; echo)"
echo "Grafana admin password: ${GRAFANA_PASSWD}"
echo "Kibana admin password: ${KIBANA_PASSWD}"
