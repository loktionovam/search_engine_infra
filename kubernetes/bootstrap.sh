#!/usr/bin/env bash
set -x
CLUSTER_NAME=$1
ZONE=$2
PROJECT=$3
EXTERNAL_IP=$4
SCRIPT_DIR=$(dirname $(realpath "$0"))
BOOTSTRAP_DIR="${SCRIPT_DIR}"/bootstrap
CHART_DIR="${SCRIPT_DIR}"/charts

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

echo "Gitlab root password: $(kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath={.data.password} | base64 --decode ; echo)"
