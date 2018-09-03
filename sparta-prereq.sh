#!/bin/bash
':
Run this script as sudo.
Example: ./sparta-prereq.sh
1. install wget on Centos
sudo yum -y install wget
2. download file
wget --output-document=sparta-prereq.sh https://www.dropbox.com/s/vmt1u9tplkfes17/sparta-prereq.sh?dl=0
3. set to executable
chmod 755 sparta-prereq.sh



SpartaUS Installation script for CentOS7
#https://www.liquidweb.com/kb/how-to-install-apache-on-centos-7/

Installs the base packages to run a standard SpartaUS isntall of Drupal/Apache
/MySQL and PHP7


Author: Keelee Moseley
Date: September 3, 2018

Drupal Installation: (Originally written for 8.2.6, so update for 8.5.6)
Downloads Drupal Version 8.5.6 from: https://ftp.drupal.org/files/projects/drupal-8.5.6.tar.gz
https://www.tecmint.com/install-drupal-in-centos-rhel-fedora/

Composer Installation:
https://getcomposer.org/download/

*working with Selinux
https://www.centos.org/docs/5/html/5.2/Deployment_Guide/sec-sel-enable-disable-enforcement.html
'

#Install Apache2 (httpd)
yum -y clean all
yum -y update
yum -y install httpd yum-utils
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
systemctl start httpd
systemctl enable httpd
systemctl status httpd
systemctl stop httpd


yum install mariadb-server mariadb
systemctl start mariadb
mysql_secure_installation
systemctl enable mariadb.service
firewall-cmd --add-service=mysql
setsebool -P httpd_can_network_connect_db 1

#Install PHP and apache modules
yum -y install php libapache2-mod-php php-mcrypt php-mysql php-fpm
systemctl restart httpd.service

yum install epel-release
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
yum update
yum install php72 
yum install php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache
systemctl restart httpd.service

#create PHP test file
chown apache:apache -R /var/www/html
#Temporary open html folder
chmod 777 /var/www/html

#create test document
echo -e "<?php\nphpinfo();\n?>"  > /var/www/html/phpinfo.php
chmod 755 phpinfo.php

#


#How to List Which Apache 2 Modules are Enabled on CentOS
#https://www.liquidweb.com/kb/how-to-list-which-apache-2-modules-are-enabled-on-centos-7/
apachectl -M | sort

#Install git and ziptools
yum -y install git p7zip zip unzip gzip

#Drupal Installation
wget -c https://ftp.drupal.org/files/projects/drupal-8.2.6.tar.gz
tar -zxvf drupal-8.5.6.tar.gz
mv drupal-8.5.6 /var/www/html/drupal
cd /var/www/html/drupal/sites/default/
cp default.settings.php settings.php
chown -R apache:apache /var/www/html/drupal/
chcon -R -t httpd_sys_content_rw_t /var/www/html/drupal/
chcon -R -t httpd_sys_content_rw_t /var/www/html/drupal/sites/

#create DB
mysql -u root -p
create database drupal;
create user drupaladmin@localhost identified by 'K33s33Kyl3s';
grant all on drupal.* to drupaladmin@localhost;
 flush privileges;


#Download and install Composer for dependency modules
#Start in user home directory to download
cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=bin --filename=composer
php -r "unlink('composer-setup.php');"








