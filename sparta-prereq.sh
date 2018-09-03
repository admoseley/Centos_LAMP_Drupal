#!/bin/bash
':
SpartaUS Installation script for CentOS7
#https://www.liquidweb.com/kb/how-to-install-apache-on-centos-7/

Installs the base packages to run a standard SpartaUS isntall of Drupal/Apache
/MySQL and PHP7

Author: Keelee Moseley
Date: September 3, 2018


Composer Installation:
https://getcomposer.org/download/

'

#firewalld is not installed (Installed on Minimal install)
#sudo yum install firewalld
#sudo systemctl start firewalld
#sudo systemctl enable firewalld
#sudo systemctl status firewalld


#Install Apache2 (httpd)
sudo yum clean all
sudo yum -y update
yum -y install httpd yum-utils
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
sudo systemctl stop httpd


sudo yum install mariadb-server mariadb
sudo systemctl start mariadb
sudo mysql_secure_installation
sudo systemctl enable mariadb.service
firewall-cmd --add-service=mysql

#Install PHP and apache modules
yum -y install php libapache2-mod-php php-mcrypt php-mysql php-fpm
sudo systemctl restart httpd.service

yum install epel-release
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72
sudo yum update
sudo yum install php72 
sudo yum install php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache

#create PHP test file
echo -e "<?php\nphpinfo();\n?>"  > /var/www/html/phpinfo.php

#


#How to List Which Apache 2 Modules are Enabled on CentOS
#https://www.liquidweb.com/kb/how-to-list-which-apache-2-modules-are-enabled-on-centos-7/
apachectl -M | sort

#Install git and ziptools
yum -y install git p7zip zip unzip

#Drupal Installation



#Download and install Composer for dependency modules
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;
php composer-setup.php --install-dir=bin --filename=composer
php bin/composer
sudo mv composer.phar /usr/local/bin/composer





