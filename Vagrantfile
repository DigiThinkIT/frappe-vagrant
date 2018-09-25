# -*- mode: ruby -*-
# vi: set ft=ruby :

# Windows admin guard requirement
if Vagrant::Util::Platform.windows? then
  def is_windows_admin?
    (`reg query HKU\\S-1-5-19 2>&1` =~ /ERROR/).nil?
  end

  unless is_windows_admin?
    puts "This vagrant requires running in admin to enable symlinks on host."
    exit 1
  end
end

# Plugins
#
# Check if the first argument to the vagrant
# command is plugin or not to avoid the loop
if ARGV[0] != 'plugin'

  # Define the plugins in an array format
  required_plugins = [
    'vagrant-vbguest'
  ]         

  # Windows specific plugins
  if Vagrant::Util::Platform.windows? then
    required_plugins.push('vagrant-fsnotify')
  end

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

  # Windows specific synced_folder settings
  if Vagrant::Util::Platform.windows? then
    if Vagrant.has_plugin?("vagrant-fsnotify") then
      # uses fsnotify to simulate file events on guest from windows
      config.vm.synced_folder "./", "/vagrant", fsnotify: [:modified, :removed], exclude: ["*.pyc", "*.pyd", "*.pyo", ".git/*"]
      # On windows, we auto start fsnotify.
      config.trigger.after :up, :reload do |t|
        t.name = "FSNotify"
	t.info = "Starts the fsnotify watcher plugin"
        t.run = { inline: "vagrant fsnotify" }
      end
    end
  else
    config.vm.synced_folder "./", "/vagrant"
  end

  
  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory and CPU on the VM:
     vb.memory = "2048"
     vb.cpus = 2
     # uses dns host resolver to prevent connectivity issues.
     vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
     
    if Vagrant::Util::Platform.windows? then
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end

  end

  # ups the inotify watches
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    cp /vagrant/install.sh /tmp/
    cp /vagrant/mysql.conf /tmp/
    cd /tmp
    chmod +x install.sh
    ./install.sh

  SHELL
end
