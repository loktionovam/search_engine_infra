# search engine infra

Инфрастурктурный репозиторий для проектов [express42/search_engine_crawler](https://github.com/express42/search_engine_crawler) [express42/search_engine_ui](https://github.com/express42/search_engine_ui)

## Необходимые компоненты

- docker engine
- make

## Запуск

### На локальной машине

- Склонировать подмодули

```bash
git submodule init
git submodule update
```

- Запустить проект

```bash
make up
```

После запуска будут доступны:

- Веб-интерфейс [crawler_ui](http://localhost:8000)
- Веб-интерфес [grafana](http://localhost:3000)
- Веб-интерфейс [prometheus](http://localhost:9090)
