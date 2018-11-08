# Changelog
Все существенные изменения в проекте будут задокументированы здесь

Формат основан на [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
и этот проект придерживается [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
