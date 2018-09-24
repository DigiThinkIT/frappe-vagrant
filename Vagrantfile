# -*- mode: ruby -*-
# vi: set ft=ruby :

# Plugins
#
# Check if the first argument to the vagrant
# command is plugin or not to avoid the loop
if ARGV[0] != 'plugin'

  # Define the plugins in an array format
  required_plugins = [
    'vagrant-vbguest'
  ]         
  plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
  if not plugins_to_install.empty?

    puts "Installing plugins: #{plugins_to_install.join(' ')}"
    if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
    else
      abort "Installation of one or more plugins has failed. Aborting."
    end

  end
end

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
