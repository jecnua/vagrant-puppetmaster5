# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # VirtualBox.
  # `vagrant up virtualbox --provider=virtualbox`
  config.vm.define "virtualbox" do |virtualbox|
    virtualbox.vm.hostname = "virtualbox-ubuntu1604"
    virtualbox.vm.box = "ubuntu/xenial64"
    virtualbox.vm.network :private_network, ip: "172.16.3.2"

    config.vm.provider :virtualbox do |v|
      v.gui = false
      v.memory = 2048
      v.cpus = 2
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
    end

    config.vm.provision "shell", path: "/Users/fabrizio.sabatini/git/workdigitalpacker-wdpuppetmaster/bootstrap.sh"
  end
end
