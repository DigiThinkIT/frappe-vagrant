# Set noninteractive and set mariadb password
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mariadb-server-10.2 mysql-server/root_password password frappe'
sudo debconf-set-selections <<< 'mariadb-server-10.2 mysql-server/root_password_again password frappe'

# MariaDB Repo
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.2/ubuntu xenial main'

# Yarn Repo
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# NodeJS Repo
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# Install packages
sudo apt-get install -y git python-dev redis-server curl software-properties-common mariadb-server-10.2 libmysqlclient-dev nodejs yarn python-pip

# Configure MariaDB
sudo cp mysql.conf /etc/mysql/conf.d/mariadb.cnf
sudo service mysql restart

# Install bench package and init bench folder
cd /home/vagrant/
git clone https://github.com/frappe/bench .bench
sudo pip install ./.bench
bench init frappe-bench

## Create site and set it as default
cd /home/vagrant/frappe-bench
bench new-site site1.local --mariadb-root-password frappe --admin-password frappe
bench use site1.local

# Enable developer mode
bench set-config "developer_mode" 1

# Move apps to shared Vagrant folder
mv /home/vagrant/frappe-bench/apps /vagrant/
mkdir -p /home/vagrant/frappe-bench/apps

# Fixes Redis warning about memory and cpu latency.
echo 'never' | sudo tee --append /sys/kernel/mm/transparent_hugepage/enabled

# Fixes redis warning about background saves
echo 'vm.overcommit_memory = 1' | sudo tee --append /etc/sysctl.conf
# set without restart
sudo sysctl vm.overcommit_memory=1

# Fixes redis issue with low backlog reservation
echo 'net.core.somaxconn = 511' | sudo tee --append /etc/sysctl.conf
# set without restart
sudo sysctl net.core.somaxconn=511


# Auto-mount shared folder to into bench. Make sure we only mount once.
echo "
if mount | grep /vagrant/apps > /dev/null; then
	echo '/vagrant/apps already mounted.'
else
	sudo mount --bind /vagrant/apps /home/vagrant/frappe-bench/apps
fi
" >> ~/.profile
