# Frappe Development Vagrant Box

This is a Vagrantfile that builds frappe from scratch that shares the apps folder automatically, so you don't need to set it up yourself.

Features : 

* Minimal installation
* Shares the `apps` folder in `frappe-bench` in the vagrant folder
* By default only Frappe is installed, without any site, so do make one
* Access your site on port `8000`
* Default MariaDB password is "frappe"

Make sure you have vagrant installed and virtual box:

https://www.vagrantup.com/

https://www.virtualbox.org/

info about vagrant and virtualbox:

https://www.vagrantup.com/docs/virtualbox/

## Setup


1) Clone this repo somewhere in your host machine, open a terminal and cd into the directory.

2) Install required plguins : 
```bash
vagrant plugin install vagrant-vbguest vagrant-notify-forwarder
```

3) Kick off vagrant box setup, this will handle everything for you:
```bash
   vagrant up
```

4) Go make some coffee this will take a while.

5) Once it's all done, and there's no errors, run
```bash
vagrant ssh
```
This will ssh you into the VBox and you'll have a ready `frappe-bench` folder for you.

6) You know the rest :)
