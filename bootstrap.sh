#!/bin/bash
# this script configure minimal env to start ansible bootstrap playbook
set -x
set -e

GCP_PROJECT=$1
GCP_SERVICE_ACCOUNT=ansible-$(date +%s)

sudo apt-get update
sudo apt-get install --yes autoconf curl gcc python-dev virtualenv unzip

# virtualenv don't working without configured locales
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
sudo dpkg-reconfigure locales

echo "Install gcloud"
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install --yes google-cloud-sdk

echo "Configure gcloud ansible service account"
gcloud init
gcloud iam service-accounts create ${GCP_SERVICE_ACCOUNT} --display-name ${GCP_SERVICE_ACCOUNT}
gcloud iam service-accounts keys create infra/ansible/environments/stage/gce-service-account.json --iam-account ${GCP_SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${GCP_PROJECT} --member serviceAccount:${GCP_SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com --role roles/editor

echo "Create Application Default Credentials (ADC)"
gcloud auth application-default login

cp infra/ansible/environments/stage/gce-service-account.json infra/ansible/environments/prod/gce-service-account.json

# Create virtual environment and continue bootstrap with ansible
cd infra/ansible
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
ansible-playbook -K playbooks/bootstrap.yml --extra-vars="gcp_project=$GCP_PROJECT"
