docker_host
=========

Configuration docker host

Requirements
------------

none

Role Variables
--------------

```yaml
# List of packages that are needed for the role bootstrap
docker_host_prerequisite_packages
  - apt-transport-https
  - ca-certificates
  - curl
  - software-properties-common
  - python-pip
  - virtualenv
```

```yaml
# Docker CE version
# For example
docker_host_version: stable
```

```yaml
# Role repositories list
# For example
docker_host_repos:
  - deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial {{ docker_host_version }}
```

```yaml
# Additional python modules related to docker engine with versions
# For example
docker_host_python_modules:
  - { module: docker, version: 3.4.1 }

```

```yaml
# User which will be added to docker group
# For example
docker_host_user: docker-user
```

```yaml
# Docker daemon configuration
docker_host_config_file: /etc/docker/daemon.json

# define docker daemon config in this variable. This variable will be rendered to daemon.json during role execution
docker_host_config: {}
```

Dependencies
------------

none

Example Playbook
----------------

```yaml
    - hosts: docker-hosts
      roles:
         - { role: loktionovam.docker_host, docker_host_version: edge }
```

License
-------

BSD

Author Information
------------------

Aleksandr Loktionov
