gce_py
=========

Роль для настройки dynamic inventory в ansible через gce.py

Requirements
------------

- На целевой машине должен существовать файл с credentials в формате json от google service account

- Предполагается, что структура каталогов ansible выглядит так

```bash
├── environments
│   ├── prod
│   │   └── group_vars
│   └── stage
│       └── group_vars
├── playbooks
└── roles
└── ansible.cfg
```

- Предполагается, что ansible.cfg расположен в корне репозитория ansible

Role Variables
--------------

- gce_py_ansible_path - путь к репозиторию ansible в котором нужно настроить dynamic inventory

- gce_py_env - окружение (имя подкаталога в environments). Например, prod

- gce_py_pem_file_path - путь к файлу с credentials от google service account

- gce_py_client_email - email от google service account

- gce_py_project_id - название проекта GCP

Dependencies
------------

Нет

Example Playbook
----------------

```yaml
    - hosts: localhost
      connection: local
      roles:
         - role: gce_py
           gce_py_ansible_path: /home/user/ansible
           gce_py_env: prod
           gce_py_pem_file_path: /secret/place/gce-service-account.json
           gce_py_client_email: google.service.account@gmail.com
           gce_py_project_id: Infra-1234
```

License
-------

BSD

Author Information
------------------
