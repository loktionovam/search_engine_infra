# search engine infra

Инфрастурктурный репозиторий для проектов [express42/search_engine_crawler](https://github.com/express42/search_engine_crawler) [express42/search_engine_ui](https://github.com/express42/search_engine_ui)

## Запуск

### На локальной машине

#### Необходимые компоненты

- docker engine
- make

- Склонировать подмодули

```bash
git submodule init
git submodule update
```

- Настроить `docker/.env`, `monitoring/alertmanager/alertmanager.secrets`

- Запустить проект

```bash
make up
```

После запуска будут доступны:

- Веб-интерфейс [crawler_ui](http://localhost:8000)
- Веб-интерфес [grafana](http://localhost:3000)
- Веб-интерфейс [prometheus](http://localhost:9090)
- Веб-интерфейс [kibana](http://localhost:5601)


### В GCP

#### Первоначальная настройка управляющего хоста

Предполагается, что в GCP уже создан проект `docker-12345` и приложение нужно установить на stage

- Сгенерировать пару ssh ключей и загрузить открытый ключ в список метаданных проекта (подробнее см. здесь [adding-removing-ssh-keys](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys))

```bash
ssh-keygen -b 2048 -t rsa -f ~/.ssh/docker-user  -q -N ""
```

- Запустить `scripts/bootstrap.sh` из корня проекта. Скрипт установит и настроит нужные приложения (gcloud, ansible, packer, terraform), создаст из шаблонов конфигурационные файлы, настроит динамический inventory  и т. д.

```bash
export GCP_PROJECT=docker-12345
bash scripts/bootstrap.sh -p $GCP_PROJECT
```

- Настроить следующие конфигурационные файлы (частично они уже настроены с помощью скриптов бутстрапа)

```
~/.docker/search_engine/docker/.env
~/.docker/search_engine/monitoring/alertmanager/alertmanager.secrets
infra/terraform/stage/terraform.tfvars
infra/terraform/prod/terraform.tfvars
```

#### Установка без использования kubernetes

- Развернуть приложение с помощью терраформа

```bash
source infra/ansible/.venv/bin/activate
cd infra/terraform
terraform init
terraform  apply -auto-approve
cd stage/
terraform init
terraform  apply -auto-approve
```

- Адрес приложения можно получить командой

```bash
terraform output
```

по этому адресу будут достуны:

- Веб-интерфейс crawler_ui (порт 8000)
- Веб-интерфес grafana (порт 3000)
- Веб-интерфейс prometheus (порт 9090)
- Веб-интерфейс kibana (порт 5601)

#### Установка с использованием kubernetes (предпочтительно)

- Развернуть kubernetes с помощью терраформа

```bash
source infra/ansible/.venv/bin/activate
cd kubernetes/terraform
terraform init
terraform  apply -auto-approve
cd gke/
terraform init
terraform  apply -auto-approve
```

- Просмотреть информацию о созданном кластере можно командой

```bash
gcloud container clusters list
NAME       LOCATION        MASTER_VERSION  MASTER_IP      MACHINE_TYPE  NODE_VERSION  NUM_NODES  STATUS
cluster-1  europe-west1-b  1.9.7-gke.6     xx.xx.xx.xx  g1-small      1.9.7-gke.6   4          RUNNING
```

после этого будут доступны следующие ресурсы:

- [gitlab](https://gitlab.loktionovam.com)
- [grafana](https://grafana.loktionovam.com)
- [kibana](https://kibana.loktionovam.com)

#### Настройка Gitlab и запуск проекта search-engine

- Создать группу search-engine

- В группе search-engine создать проекты crawler, ui, charts, infra и загрузить соответствующие репозитории

- Для проекта `charts` в `Settings->CI/CD` создать `Pipeline triggers`

- В группе `search-engine` в `Settings->CI/CD->Variables` добавить переменные
  - `CI_REGISTRY_PASSWORD`
  - `CI_REGISTRY_USER`
  - `SEARCH_ENGINE_DEPLOY_TOKEN`

- Собрать docker образы и развернуть приложение. Для проектов crawler, ui в `CI/CD->Pipelines` выполнить `Run Pipeline` для ветки master

после этого будет развернут staging:

- [crawler_ui_staging](http://search-engine.loktionovam.com)

Чтобы развернуть приложение в производственную среду нужно вручную подтвердить развертывание в `search-engine->CI/CD->Pipelines->production`

- [crawler_ui_production](http://search-engine.loktionovam.com)

- После пуша коммита в ветку микросервиса будут выполнены:
  - Тестирование кода
  - Сборка образа докер контейнера
    - loktionovam/search_engine_crawler:feature-xxx-feature-name
    - loktionovam/search_engine_ui:feature-xxx-feature-name
  - Пуш образа в dockerhub
  - Запуск review приложения через gitlab environments с ручным удалением
- При изменениях в мастер ветке микросервиса будут выполнены
  - Тестирование кода
  - Сборка образа докер контейнера
  - Пуш образа в dockerhub
  - Запуск приложения на stage из master ветки charts репозитория, с ручным подтверждением развертывания в производственную среду
