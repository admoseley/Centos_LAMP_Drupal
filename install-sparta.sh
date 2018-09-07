#!/bin/bash
unzip sparta-portal.zip
mv /home/kmoseley/sparta-portal/docroot /var/www/html/sparta
sudo chown -R apache:apache sparta
sudo chcon -R -t httpd_sys_content_rw_t /var/www/html/sparta
mysql -u root -p'P@ssw0rd123!' -e "create database sparta; create database ibdialog;use sparta;source /var/www/html/sparta/database/sparta.sql;source /var/www/html/sparta/database/ibdialog.sql;"
GRANT ALL PRIVILEGES ON *.* TO 'spartadb'@'localhost' IDENTIFIED BY 'P@ssw0rd123!';
create user drupaladmin@localhost identified by 'P@ssw0rd123!';
grant all on drupal.* to drupaladmin@localhost; flush privileges;"

sudo chmod 777 /var/www/html/sparta/composer.json
sudo mkdir /var/www/html/sparta/vendor
sudo composer require drush/drush