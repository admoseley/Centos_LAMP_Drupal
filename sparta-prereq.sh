#!/bin/bash
: '
Installs the base packages to run a standard SpartaUS isntall of Drupal/Apache
/MySQL and PHP7

SpartaUS Installation script for CentOS7
#https://www.liquidweb.com/kb/how-to-install-apache-on-centos-7/

#Getting Started run the following to download and install the Preq script
sudo yum -y install wget
wget --output-document=sparta-prereq.sh https://www.dropbox.com/s/vmt1u9tplkfes17/sparta-prereq.sh?dl=0
chmod 755 sparta-prereq.sh
sudo ./sparta-prereq.sh

Drupal Installation: (Originally written for 8.2.6, so update for 8.5.6)
Downloads Drupal Version 8.5.6 from: https://ftp.drupal.org/files/projects/drupal-8.5.6.tar.gz
https://www.tecmint.com/install-drupal-in-centos-rhel-fedora/

Composer Installation:
https://getcomposer.org/download/

Drush Install
http://docs.drush.org/en/master/install/

*working with Selinux
https://www.centos.org/docs/5/html/5.2/Deployment_Guide/sec-sel-enable-disable-enforcement.html

*Adding opcache to server to address drupal caching
Add this once the script is finished
http://php.net/manual/en/opcache.installation.php
add edits to /etc/php.ini
zend_extension=/opt/remi/php72/root/usr/lib64/php/modules/opcache.so
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1

Clean URLS
https://www.drupal.org/docs/8/clean-urls-in-drupal-8/fix-drupal-8-clean-urls-problems


Author: Keelee Moseley
Date: September 3, 2018
'
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Drupal Stack Installation (Apache\MySql\PHP and tools)(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"

#Install Apache2 (httpd) and configure Firewall for open port 80/443
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Run yum clean all...$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum -y clean all

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Run yum update...$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum -y update

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Install apache (httpd) and yum-utils $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum -y install httpd yum-utils

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Update FW for port 80 and 443$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Run start webservices...$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
systemctl start httpd
systemctl enable httpd
systemctl status httpd

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Install mariaDB$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum install -y mariadb-server mariadb
systemctl start mariadb

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Secure mariaDB$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
mysql_secure_installation

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Start mariaDB$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
systemctl enable mariadb.service
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)All FW allow for mariaDB$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
firewall-cmd --add-service=mysql
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Set SELINUX allow HTTPD to MARIADB$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
setsebool -P httpd_can_network_connect_db 1

#Install PHP and apache modules
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Install php modules...$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum -y install php libapache2-mod-php php-mcrypt php-mysql php-fpm

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Restart webservice...$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
systemctl restart httpd.service

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Add php7 repos$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum install -y epel-release
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
yum -y update

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Install php7 $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum install -y php72 
yum install -y php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache php70-php-gd php-gd php-mbstring
yum --enablerepo remi install -y php-xml

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Restart webservice... $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
systemctl restart httpd.service

#create PHP test file
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Change ownership of /var/www/html to apache:apache $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
chown apache:apache -R /var/www/html

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Set /var/www/html to 777 *This is temporary* $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
#Temporary open html folder
chmod -R 777 /var/www/html

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Create test php info file (phpinfo.php)$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
#create test document
echo -e "<?php\nphpinfo();\n?>"  > /var/www/html/phpinfo.php
chmod 755 /var/www/html/phpinfo.php

#How to List Which Apache 2 Modules are Enabled on CentOS
#https://www.liquidweb.com/kb/how-to-list-which-apache-2-modules-are-enabled-on-centos-7/
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)View apache modules$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
apachectl -M | sort

#Install git and ziptools
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Install git and zip tools... $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
yum -y install git p7zip zip unzip gzip

#Drupal Installation

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Download Drupal 8.5.6...$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
cd
wget -c https://ftp.drupal.org/files/projects/drupal-8.5.6.tar.gz
tar -zxvf drupal-8.5.6.tar.gz

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)copy drupal to /var/www/html/drupal...$(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
mv drupal-8.5.6 /var/www/html/drupal
cd /var/www/html/drupal/sites/default/
cp default.settings.php settings.php
chown -R apache:apache /var/www/html/drupal/
chcon -R -t httpd_sys_content_rw_t /var/www/html/drupal/
chcon -R -t httpd_sys_content_rw_t /var/www/html/drupal/sites/

#create Maria/MySQL DB
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Create MySQL Databases... $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
mysql -u root -p'P@ssw0rd123!' -e "create database drupal; create user drupaladmin@localhost identified by 'P@ssw0rd123!'; grant all on drupal.* to drupaladmin@localhost; flush privileges;"

#Download and install Composer for dependency modules
#Start in user home directory to download
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Install Composer... $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
sleep 10
cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/bin --filename=composer
php -r "unlink('composer-setup.php');"

#Add Drush
#http://docs.drush.org/en/master/install/
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)Install composer/drush in /var/www/html/drupal (tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------(tput sgr 0)"
cd /var/www/html/drupal
composer require drush/drush


#Sparta Install
#Upload git clone to server home directory
#unzip the files in the home dir
#unzip sparta-portal.zip
#Move the docroot to /var/www/html/sparta
#mv /home/kmoseley/sparta-portal/docroot /var/www/html/sparta
#Create MySQL dbs and import the data
#mysql -u root -p'P@ssw0rd123!' -e "create database sparta; create database ibdialog;use sparta;source /var/www/html/sparta/database/sparta.sql;use ibdialog;source /var/www/html/sparta/database/ibdialog.sql;"