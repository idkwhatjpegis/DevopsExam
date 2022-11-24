# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  config.vm.define "pipelines" do |pipelines|
    pipelines.vm.box = "shekeriev/debian-11"
    pipelines.vm.hostname = "pipelines.do1.exam"
    pipelines.vm.network "private_network", ip: "192.168.111.100"
    pipelines.vm.provision "shell", path: "add-hosts.sh"
    pipelines.vm.provision "shell", path: "install_jenkins.sh"
    pipelines.vm.provision "shell", path: "setup_jenkins.sh"

    pipelines.vm.provider "virtualbox" do |v|
      v.gui = false
      v.memory = 4096
      v.cpus = 2
    end
    
    pipelines.vm.synced_folder "pipesandcontainers/", "/vagrant"
  end
  
  config.vm.define "containers" do |containers|
    containers.vm.box = "shekeriev/debian-11"
    containers.vm.hostname = "containers.do1.exam"
    containers.vm.network "private_network", ip: "192.168.111.101"
    containers.vm.provision "shell", path: "add-hosts.sh"
    containers.vm.provision "shell", path: "install_docker.sh"
    containers.vm.provision "shell", path: "setup_gitea.sh"

    containers.vm.provider "virtualbox" do |v|
      v.gui = false
      v.memory = 4096
      v.cpus = 2
    end
    containers.vm.synced_folder "pipesandcontainers/",  "/vagrant"
  end
  
  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.box = "shekeriev/debian-11"
    monitoring.vm.hostname = "monitoring.do1.exam"
    monitoring.vm.network "private_network", ip: "192.168.111.102"
    monitoring.vm.provision "shell", path: "add-hosts.sh"
    monitoring.vm.provision "shell", path: "install-elastic-stack.sh"

    monitoring.vm.provider "virtualbox" do |v|
      v.gui = false
      v.memory = 4096
      v.cpus = 2
      v.customize ["modifyvm", :id, "--usb", "on"]
      v.customize ["modifyvm", :id, "--usbehci", "off"]
    end
    monitoring.vm.synced_folder "files/", "/vagrant"
  end
  
end
