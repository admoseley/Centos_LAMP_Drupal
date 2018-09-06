#!/bin/bash
cd /home/kmoseley
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) Unzipping Sparta-portal.zip from Git Repos            $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
sleep 10
unzip ./sparta-portal.zip

echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) moving Sparta-portal to web dir /var/www/html         $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
sleep 10
mv /home/kmoseley/sparta-portal/docroot /var/www/html/sparta
cd /var/www/html
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) set ownership web dir /var/www/html/sparta            $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
sudo chown -R apache:apache ./sparta
sudo chcon -R -t httpd_sys_content_rw_t /var/www/html/sparta
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) Create sparta database                                $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
mysql -u root -p'P@ssw0rd123!' -e "create database sparta; create database ibdialog;use sparta;source /var/www/html/sparta/databas
e/sparta.sql;use ibdialog;source /var/www/html/sparta/database/ibdialog.sql;GRANT ALL PRIVILEGES ON *.* TO 'spartadb'@'localhost' IDENTIFIED BY 'P@ssw0rd123!';"
cd /var/www/html/sparta
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) Make composer.json writeable                          $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
sudo chmod 777 ./composer.json
sudo mkdir /var/www/html/sparta/vendor
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) Run composer to get dependency modules                $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
sleep 10
sudo composer require drush/drush
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) Rename settings.php file to  *.old                    $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
cp /var/www/html/sparta/sites/default/settings.php /var/www/html/sparta/sites/default/settings.php.old
#-rw-r--r--. 1 root root 11753 Jun 26 14:07 httpd.conf
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) Copy new httpd.conf file (save old to httpd.old)      $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.old
chmod 644 /home/kmoseley/Centos_LAMP_Drupal/httpd.conf
cp /home/kmoseley/Centos_LAMP_Drupal/httpd.conf /etc/httpd/conf/httpd.conf
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7) Copy new php.ini file (save old to /etc/php.old)      $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)------------------------------------------------------ $(tput sgr 0)"
cp /etc/php.ini /etc/php.old
chmod 644 /home/kmoseley/Centos_LAMP_Drupal/php.ini
cp /home/kmoseley/Centos_LAMP_Drupal/php.ini /etc/php.ini
