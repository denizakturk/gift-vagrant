#!/usr/bin/env bash

#sudo apt install -y --force-yes apt-transport-https lsb-release ca-certificates
#sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
#sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
#sudo apt update -y --force-yes

#sudo apt install -y --force-yes php7.2 php7.2-common php7.2-cli php7.2-fpm

sudo apt-get install -y --force-yes apt-transport-https lsb-release ca-certificates
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sudo echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt-get update && sudo apt-get upgrade -y --force-yes
sudo apt-get install -y --force-yes php7.2-cli php7.2-mbstring php7.2-zip php7.2-xml php7.2-mysql php7.2-curl
sudo apt-get install -y --force-yes .*php7.2
sudo apt-get install php7.2-opcache
sudo apt-get install -y --force-yes redis-server
sudo apt-get install -y --force-yes redis-tools php-redis

sudo echo "--> Apache mods <--"

sudo apt install -y --force-yes php libapache2-mod-php

sudo apt-get install -y --force-yes apache2 apache2-doc apache2-utils

sudo a2dismod mpm_event
sudo a2enmod mpm_prefork
sudo a2enmod rewrite
sudo a2enmod headers
sudo service apache2 restart

sudo a2dissite 000-default.conf

# Install mysql other version maria db
sudo echo "--> Installing Mysql Server <--"
# Install MySQL
	echo 'mysql-server mysql-server/root_password password vagrant' | debconf-set-selections
	sudo echo 'mysql-server mysql-server/root_password_again password vagrant' | debconf-set-selections
	sudo apt-get install -y --force-yes mysql-server

sudo echo "Updating mysql configs in /etc/mysql/my.cnf."
if [ sed -i "s/bind-address.*/# bind-address = 0.0.0.0/" /etc/mysql/my.cnf ]; then
    sudo echo "Updated mysql bind address in /etc/mysql/my.cnf to 0.0.0.0 to allow external connections."
fi
sudo /etc/init.d/mysql stop
sudo /etc/init.d/mysql start

sudo echo "--> Install git <--"

sudo apt-get install -y --force-yes git-core
sudo apt-get install -y --force-yes git-ftp

sudo echo "--> Install composer <--"

sudo php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"

sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

sudo rm /tmp/composer-setup.php

sudo echo "--> Clone Repository <--"

cd /var/www/html/
sudo git clone https://github.com/denizakturk/gifts.git
cd gifts
composer dump-autoload
sudo mkdir var
sudo mkdir var/log
sudo cp /var/www/html/vhost/gifts.com.conf /etc/apache2/sites-available/gifts.com.conf
sudo a2ensite gifts.com.conf
sudo service apache2 restart

sudo php /var/www/html/gifts/config/create-database.php

sudo apt-get install -y --force-yes ntp ntpdate

sudo service ntp stop
sudo ntpdate -s time.nist.gov
sudo service ntp start

sudo echo "--> End of shell script <--"
#fi