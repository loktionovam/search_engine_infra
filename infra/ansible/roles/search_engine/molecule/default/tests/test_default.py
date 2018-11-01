import os
import pytest
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("pkgs", [
    "make",
    "git",
])
def test_search_engine_packages(host, pkgs):
    pkg = host.package(pkgs)

    assert pkg.is_installed


def test_docker_compose_env_file(host):
    f = host.file('/home/vagrant/search-engine/docker/.env')

    assert f.is_file
    assert f.user == 'vagrant'
    assert f.group == 'vagrant'
    assert oct(f.mode) == '0640'


def test_alertmanager_secrets_file(host):
    f = host.file(
        '/home/vagrant/search-engine/monitoring/'
        'alertmanager/alertmanager.secrets')

    assert f.is_file
    assert f.user == 'vagrant'
    assert f.group == 'vagrant'
    assert oct(f.mode) == '0640'


@pytest.mark.parametrize("search_engine_ports", [
    'tcp://0.0.0.0:8000',
    'tcp://0.0.0.0:3000',
    'tcp://0.0.0.0:9090'
])
def test_search_engine_ports(host, search_engine_ports):
    p = host.socket(search_engine_ports)
    assert p.is_listening


@pytest.mark.parametrize("containers", [
    'search_engine_grafana_1',
    'search_engine_node-exporter_1',
    'search_engine_mongodb_exporter_1',
    'search_engine_alertmanager_1',
    'search_engine_cadvisor_1',
    'search_engine_prometheus_1',
    'search_engine_crawler_1',
    'search_engine_crawler_db_1',
    'search_engine_ui_1',
    'search_engine_rabbitmq_1',
])
def test_docker_container_running(host, containers):

    assert host.check_output(
        'docker inspect --format \{\{\.State\.Status\}\} ' + containers
    ) == 'running'
