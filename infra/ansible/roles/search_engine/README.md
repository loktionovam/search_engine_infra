Role Name
=========

Install and run search engine microservices via docker compose

Requirements
------------

none

Role Variables
--------------

- `env` variable should be overrided in the plabook (valid values `local/stage/prod`)

```yaml
env: local
```

- Packages that are needed for the correct execution of the role

```yaml
search_engine_prerequisite_packages:
  - make
  - git
```

- The path where the search engine infra repository will be cloned

```yaml
search_engine_work_dir: /home/docker-user/search-engine
```

- Remote address of the search engine infra repository

```yaml
search_engine_repo: https://github.com/loktionovam/search_engine_infra.git
```

- Makefile target. By default `up` target build docker images and start containers via docker compose

```yaml
search_engine_make_target: up
```

- Credentials files on the management node

```yaml
search_engine_docker_compose_env: ~/.docker/search_engine/docker/.env
search_engine_alertmanager_secrets: ~/.docker/search_engine/monitoring/alertmanager/alertmanager.secrets
```

Dependencies
------------

- docker_host

Example Playbook
----------------

```yaml
---
- name: Install docker container runtime and start search engine application
  hosts: tag_docker-host

  roles:
    - docker_host
    - role: search_engine
      env: prod

```

License
-------

BSD

Author Information
------------------

Aleksandr Loktionov
