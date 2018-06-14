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

# Move apps to shared Vagrant folder
mv /home/vagrant/frappe-bench/apps /vagrant/
mkdir -p /home/vagrant/frappe-bench/apps

# Auto-mount shared folder to into bench
echo -e "\nsudo mount --bind /vagrant/apps /home/vagrant/frappe-bench/apps\n" >> ~/.profile