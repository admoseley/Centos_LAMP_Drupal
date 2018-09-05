#!/bin/bash
cd /home/kmoseley
unzip ./sparta-portal.zip
mv /home/kmoseley/sparta-portal/docroot /var/www/html/sparta
cd /var/www/html
sudo chown -R apache:apache ./sparta
sudo chcon -R -t httpd_sys_content_rw_t /var/www/html/sparta
mysql -u root -p'P@ssw0rd123!' -e "create database sparta; create database ibdialog;use sparta;source /var/www/html/sparta/databas
e/sparta.sql;source /var/www/html/sparta/database/ibdialog.sql;GRANT ALL PRIVILEGES ON *.* TO 'spartadb'@'localhost' IDENTIFIED BY 'P@ssw0rd123!';"
cd /var/www/html/sparta
sudo chmod 777 ./composer.json
sudo mkdir /var/www/html/sparta/vendor
sudo composer require drush/drush
mv /var/www/html/sparta/sites/default/settings.php /var/www/html/sparta/sites/default/settings.php.old