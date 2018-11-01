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

### В GCP

Предполагается, что в GCP уже создан проект `docker-12345` и приложение нужно установить на stage

- Сгенерировать пару ssh ключей и загрузить открытый ключ в список метаданных проекта (подробнее см. здесь [adding-removing-ssh-keys](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys))

```bash
ssh-keygen -b 2048 -t rsa -f ~/.ssh/docker-user  -q -N ""
```

- Запустить скрипт `bootstrap.sh` из корня проекта. Скрипт установит и настроит нужные приложения (gcloud, ansible, packer, terraform), создаст из шаблонов конфигурационные файлы, настроит динамический inventory  и т. д.

```bash
export GCP_PROJECT=docker-12345
bash bootstrap.sh $GCP_PROJECT
```

- Настроить следующие конфигурационные файлы (частично они уже настроены с помощью скриптов бутстрапа)

```
~/.docker/search_engine/docker/.env
~/.docker/search_engine/monitoring/alertmanager/alertmanager.secrets
infra/terraform/stage/terraform.tfvars
infra/terraform/prod/terraform.tfvars
```

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
