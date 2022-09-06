# search engine infra

The infrastructure repository for projects [express42/search_engine_crawler](https://github.com/express42/search_engine_crawler) [express42/search_engine_ui](https://github.com/express42/search_engine_ui)

* [search engine infra](#search-engine-infra)
  * [How-to start](#how-to-start)
    * [On the local host](#on-the-local-host)
      * [Prerequisite](#prerequisite)
    * [On GCP](#on-gcp)
      * [Bootstrapping the management host](#bootstrapping-the-management-host)
      * [Installing without kubernetes](#installing-without-kubernetes)
      * [Installing with kubernetes (preffered)](#installing-with-kubernetes-preffered)
      * [Setup Gitlab and start search-engine project](#setup-gitlab-and-start-search-engine-project)

## How-to start

### On the local host

#### Prerequisite

* docker engine
* make

* Clone the git submodules

```bash
git submodule init
git submodule update
```

* Setup `docker/.env`, `monitoring/alertmanager/alertmanager.secrets`

* Start the project

```bash
make up
```

After that you can use these services:

* [crawler_ui](http://localhost:8000)
* [grafana](http://localhost:3000)
* [prometheus](http://localhost:9090)
* [kibana](http://localhost:5601)

### On GCP

#### Bootstrapping the management host

Is is assumed that there is already a project `docker-12345` you the application should be installed on the stage environment

* Generate the ssh keypair and upload the public key to metadata of the project (how to do this [adding-removing-ssh-keys](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys))

```bash
ssh-keygen -b 2048 -t rsa -f ~/.ssh/docker-user  -q -N ""
```

* Start `scripts/bootstrap.sh` from the root of the project. The script will install and bootstrap the necessary applications (gcloud, ansible, packer, terraform), create the configuration files from the templates , bootstrap a dynamic inventory  and so on

```bash
export GCP_PROJECT=docker-12345
bash scripts/bootstrap.sh -p $GCP_PROJECT
```

* Setup these configuration files (partially they are already set up by the bootstrap scripts)

```
~/.docker/search_engine/docker/.env
~/.docker/search_engine/monitoring/alertmanager/alertmanager.secrets
infra/terraform/stage/terraform.tfvars
infra/terraform/prod/terraform.tfvars
```

#### Installing without kubernetes

* Deploy the application via terraform

```bash
source infra/ansible/.venv/bin/activate
cd infra/terraform
terraform init
terraform  apply -auto-approve
cd stage/
terraform init
terraform  apply -auto-approve
```

* Get the application address

```bash
terraform output
```

there will be list of services:

* crawler_ui (порт 8000)
* grafana (порт 3000)
* prometheus (порт 9090)
* kibana (порт 5601)

#### Installing with kubernetes (preffered)

* Deploy a kubernetes cluster

```bash
source infra/ansible/.venv/bin/activate
cd kubernetes/terraform
terraform init
terraform  apply -auto-approve
cd gke/
terraform init
terraform  apply -auto-approve
```

* Check your cluster out

```bash
gcloud container clusters list
NAME       LOCATION        MASTER_VERSION  MASTER_IP      MACHINE_TYPE  NODE_VERSION  NUM_NODES  STATUS
cluster-1  europe-west1-b  1.9.7-gke.6     xx.xx.xx.xx  g1-small      1.9.7-gke.6   4          RUNNING
```

these resources will be created:

* [gitlab](https://gitlab.loktionovam.com)
* [grafana](https://grafana.loktionovam.com)
* [kibana](https://kibana.loktionovam.com)

#### Setup Gitlab and start search-engine project

* Create a group name `search-engine` in the gitlab

* Create `crawler, ui, charts, infra` projects tn the `search-engine` group and upload the corresponding repositories to them

* In the `charts` projects setup `Pipeline triggers` in the `Settings->CI/CD`

* In the`search-engine` group add variables to `Settings->CI/CD->Variables`:
  * `CI_REGISTRY_PASSWORD`
  * `CI_REGISTRY_USER`
  * `SEARCH_ENGINE_DEPLOY_TOKEN`

* Build the docker images and deploy the application. In  `crawler and ui` projects run the pipeline in the master branch:

after the pipeline will be completed there will be staging environment:

* [crawler_ui_staging](http://search-engine.loktionovam.com)

To deploy the application to a production environment you need manually approve the deployment here `search-engine->CI/CD->Pipelines->production`

* [crawler_ui_production](http://search-engine.loktionovam.com)

* After you push a commit to a microservice branch these steps will be executed:
  * Test of code
  * Building docker images:
    * loktionovam/search_engine_crawler:feature-xxx-feature-name
    * loktionovam/search_engine_ui:feature-xxx-feature-name
  * Push these docker images to dockerhub
  * Запуск review приложения через gitlab environments с ручным удалением
* On changing the master branch of a microservice these steps will be executed:
  * Test of code
  * Build and push docker image
  * Deploy the application to the stage environment from the master branch of charts repository, with manual approvement of deployment to the production environment
