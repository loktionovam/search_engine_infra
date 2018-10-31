import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_docker_package(host):
    p = host.package('docker-ce')

    assert p.is_installed


def test_docker_service(host):
    s = host.service('docker')

    assert s.is_running
    assert s.is_enabled


def test_docker_python_modules(host):
    m = host.pip_package.get_packages(pip_path='/usr/bin/pip')

    assert m['docker']['version'] == '3.4.1'
    assert m['docker-compose']['version'] == '1.22.0'
    assert m['PyYAML']['version'] == '3.11'


def test_docker_user_group(host):
    u = host.user('docker-user')

    assert 'docker' in u.groups


def test_docker_container_running(host):
    with host.sudo('docker-user'):
        host.check_output("docker run hello-world")


def test_docker_daemon_conf(host):
    f = host.file('/etc/docker/daemon.json')

    assert f.content_string == '{}'
