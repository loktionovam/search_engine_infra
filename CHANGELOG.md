# Changelog
Все существенные изменения в проекте будут задокументированы здесь

Формат основан на [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
и этот проект придерживается [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.5.1] - 2018-11-20
### Changed

- n1-standard-2 заменены на n1-highmem-2 in k8s

## [2.5.0] - 2018-11-19
### Added

- Добавлен Dockerfile для fluend (#34)
- Добавлен docker-compose-logging для установки EFK без использования k8s (#34)

## [2.4.0] - 2018-11-19
### Added

- В grafana добавлен Kubernetes Cluster dashboard

### Changed

- В bootstrap.yml убран хардкод версий приложений
- Подмодуль charts обновлен до версии 2.3.0 (#31)

## [2.3.0] - 2018-11-19
### Added

- Установка EFK в k8s bootstrap
- UI service, crawler service, mongodb overview grafana dashboards

### Changed

- Подмодуль charts обновлен до версии 2.2.0
- Подмодуль crawler обновлен до версии 1.1.0
- Подмодуль ui обновлен до версии 1.1.0
- Подмодуль charts обновлен до версии 2.1.0

## [2.2.0] - 2018-11-18
### Added

- Инсталляция prometheus, grafana в kubernetes - версия репозитория helm чартов 2.0.0

### Changed

- prometheus переименован в prometheus-server в конфигурации docker compose

## [2.1.0] - 2018-11-15
### Added

- Развертывание dev, stage, prod сред с помощью Gitlab CI/CD
- Доменная зона для проекта - loktionovam.com
- Управление записями Google cloud DNS через терраформ
- Инсталляция gitlab в kubernetes

### Changed

- src/search_engine_ui, src/search_engine_crawler, kubernetes/charts вынесены в отдельные репозитории и подключены как подмодули git

## [2.0.0] - 2018-11-09
### Added

- crawler, ui, search_engine helm chart
- Бутстрап k8s через ресурс bootstrap_gke в терраформе
- Добавлен Vagrantfile для тестирования настройки управляющего хоста
- Добавлена конфигурация terraform для развертывания GKE

### Changed

- search_engine_rabbitmq обновлен до 1.9
- Плейбук bootstrap.yml разделен на bootstrap, bootstrap_gce, bootstrap_gke
- В плейбук bootstrap.yml добавлена установка kubectl, helm и настройка terraform для деплоя в GKE

## [1.2.0] - 2018-11-07
### Added

- Добавлено описание ansible роли `search_engine`

### Changed

- В скрипт `bootstrap.sh` добавлен контроль входных параметров, логирование и отладка. Скрипт перемещен в каталог `scripts` Обновлена документация `README.md` в корне проекта

## [1.1.0] - 2018-11-01
### Added

- Добавлены скрипты `bootstrap.sh, infra/ansible/playbook/bootstrap.yml` для автоматической настройки управляющего хоста (установка и настройка нужных приложений (gcloud, ansible, packer, terraform), создание из шаблонов конфигурационных файлов, настройка динамического inventory  и т. д.)
- Добавлена конфигурация для terraform для создания инстанса в GCP и развертывания приложения через ansible
- Добавлена конфигурация для packer для подготовки образа docker_host в GCP
- Добавлена конфигурация для ansible
  - Роль gce_py для настройки динамического инвентори на локальной машине
  - Роль docker_host для настройки docker на инстансе GCP
  - Роль search_engine для деплоя приложения на инстанс в GCP

### Changed

- Подмодули git теперь используют https вместо ssh
- Файлы `.example` шаблонизированы через jinja2 и теперь имеют расширение `.example.j2`

## [1.0.1] - 2018-10-31
### Added

- Добавлена конфигурация мониторинга - prometheus, grafana, alertmanager
- Добавлен Dockerfile для search_engine_rabbitmq
- Для loktionovam/search_engine_ui, loktionovam/search_engine_ui написаны Dockerfile, добавлена конфигурация docker-compose
- Проекты loktionovam/search_engine_ui, loktionovam/search_engine_ui добавлены к этому проекту как подмодули git

### Changed

### Removed
