#!/bin/bash

# set to stop on errors
set -e

# isntall libraries
sudo yum update -y
sudo yum -y install php-mysqlnd
sudo yum -y install php-fpm mariadb-server httpd
sudo yum -y install tar curl php-json
sudo yum -y install php
echo Libraries installed

# start and configure firewalld
sudo yum -y install firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
echo Firewall configured

sudo systemctl start mariadb
sudo systemctl start httpd
sudo systemctl enable mariadb
sudo systemctl enable httpd
echo MariaDB and Apache2 started and enabled

sudo mysql -uroot -e "CREATE DATABASE IF NOT EXISTS wordpress";
sudo mysql -uroot -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'pass'";
sudo mysql -uroot -e "GRANT ALL ON wordpress.* TO 'admin'@'localhost'";
echo Created new database and gave persmissions to user

sudo curl https://wordpress.org/latest.tar.gz --output wordpress.tar.gz
tar xf wordpress.tar.gz
sudo cp -r wordpress /var/www/html
echo curled wordpress and untarred and copied to ...html/wordpress

sudo chown -R apache:apache /var/www/html/wordpress
sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
echo changed file ownership

echo DONE!


