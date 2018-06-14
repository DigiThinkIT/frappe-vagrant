# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vbguest.auto_update=false
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 9000, host: 9000
  config.vm.network "forwarded_port", guest: 6787, host: 6787

  config.ssh.forward_agent = true

  config.vm.synced_folder "./", "/vagrant"

  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory and CPU on the VM:
     vb.memory = "2048"
     vb.cpus = 2
  end

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    cp /vagrant/install.sh /tmp/
    cp /vagrant/mysql.conf /tmp/
    cd /tmp
    chmod +x install.sh
    ./install.sh

  SHELL
end
