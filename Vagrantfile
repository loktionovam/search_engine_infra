Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |v|
    v.memory = 1024
  end

  config.vm.define "mgmt-host" do |mgmt|
    mgmt.vm.box = "ubuntu/xenial64"
    mgmt.vm.hostname = "mgmt-host"
    mgmt.vm.network :private_network, ip: "10.10.10.10"
    mgmt.vm.synced_folder "./", "/home/vagrant/search_engine_infra/"
  end
end
