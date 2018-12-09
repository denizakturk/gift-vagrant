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
sudo apt-get install -y --force-yes redis-server
sudo apt-get install -y --force-yes redis-tools php-redis
# Not tested commands
# sudo apt-get install php7.2-sqlite3
# sudo apt-get install php7.2-opcache
sudo apt install -y --force-yes php libapache2-mod-php

sudo apt-get install -y --force-yes apache2 apache2-doc apache2-utils

sudo a2dismod mpm_event
sudo a2enmod mpm_prefork
sudo a2enmod rewrite
sudo a2enmod headers
sudo service apache2 restart

sudo a2dissite 000-default.conf

sudo mkdir /var/www/test
sudo mkdir /var/www/test/logs

sudo chmod -R 777 /var/www/test

#PHPTESTFILE=$(cat <<EOF
#<html>
#<head>
#<meta charset="UTF-8"/>
#</head>
#<body>
#<h1>Welcome, this test.local index.php</h1>
#<h2>Below lines php info</h2>

#<?php

#error_reporting(E_ALL);
#ini_set('error_reporting', E_ALL);
#ini_set('display_errors',1);

#$mysqli = new mysqli('localhost', 'root', 'vagrant');

#/*
# * This is the "official" OO way to do it,
# * BUT $connect_error was broken until PHP 5.2.9 and 5.3.0.
# */
#if ($mysqli->connect_error) {
#    die('Connect Error (' . $mysqli->connect_errno . ') '
#            . $mysqli->connect_error);
#} else { 
#echo 'Mysql Connected !';
#}
#?>

#<?php phpinfo();?>
#</body>
#</html>
#EOF
#)

#echo "${PHPTESTFILE}" > /var/www/test/index.php

#VHOSTTEST=$(cat <<EOF
#<VirtualHost *:80>
#     ServerAdmin webmaster@test.local
#     ServerName test.local
#     DocumentRoot /var/www/test
#     ErrorLog /var/www/test/logs/error.log
#     CustomLog /var/www/test/logs/access.log combined
#</VirtualHost>
#EOF
#)

#echo "${VHOSTTEST}" > /etc/apache2/sites-available/test.local.conf

#sudo a2ensite test.local.conf

#sudo systemctl restart apache2

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

sudo apt-get -y --force-yes install gcc
sudo apt install -y --force-yes ruby rails
sudo gem install sass
sudo gem install compass
sudo gem install bootstrap-sass

sudo echo "--> Install symfony <--"

composer create-project symfony/skeleton /var/www/test/symfony

cd /var/www/html/sanssende.com
sudo chmod -R 777 app/cache app/logs
composer install --no-interaction --no-progress --prefer-dist

cd /var/www/html/lotosayisal.com
sudo chmod -R 777 app/cache app/logs
composer install --no-interaction --no-progress --prefer-dist

#VHOSTSYMFONYTEST=$(cat <<EOF
#<VirtualHost *:80>
#     ServerAdmin webmaster@test.local
#     ServerName test.local
#     DocumentRoot /var/www/test/symfony/public
#     ErrorLog /var/www/test/logs/error.log
#     CustomLog /var/www/test/logs/access.log combined
#</VirtualHost>
#EOF
#)

#sudo echo "${VHOSTSYMFONYTEST}" > /etc/apache2/sites-available/symfony.local.conf

sudo cp /var/www/html/vhost/symfony.local.conf /etc/apache2/sites-available/symfony.local.conf
sudo cp /var/www/html/vhost/sanssende.com.conf /etc/apache2/sites-available/sanssende.com.conf
sudo cp /var/www/html/vhost/www.sanssende.com.conf /etc/apache2/sites-available/www.sanssende.com.conf
sudo cp /var/www/html/vhost/lotosayisal.com.conf /etc/apache2/sites-available/lotosayisal.com.conf
sudo a2ensite symfony.local.conf
sudo a2ensite sanssende.com.conf
sudo a2ensite www.sanssende.com.conf
sudo a2ensite lotosayisal.com.conf
sudo systemctl restart apache2

sudo apt-get install -y --force-yes ntp ntpdate

sudo service ntp stop
sudo ntpdate -s time.nist.gov
sudo service ntp start

sudo echo "--> End of shell script <--"
#fi