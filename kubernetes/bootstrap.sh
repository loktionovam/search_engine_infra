#!/usr/bin/env bash
set -x
CLUSTER_NAME=$1
ZONE=$2
PROJECT=$3
SCRIPT_DIR=$(dirname $(realpath "$0"))
BOOTSTRAP_DIR="${SCRIPT_DIR}"/bootstrap
CHART_DIR="${SCRIPT_DIR}"/charts

gcloud container clusters get-credentials "${CLUSTER_NAME}" --zone "${ZONE}" --project "${PROJECT}"
gcloud beta container clusters update "${CLUSTER_NAME}" --zone "${ZONE}" --monitoring-service none
gcloud beta container clusters update "${CLUSTER_NAME}" --zone "${ZONE}" --logging-service none

kubectl apply -f "${BOOTSTRAP_DIR}"/tiller.yaml
helm init --wait --service-account tiller
helm install stable/nginx-ingress --name nginx

