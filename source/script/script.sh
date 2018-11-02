#!/bin/bash

# Wordpress initial
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y apt-transport-https azure-cli
apt-get install -y --allow-unauthenticated --no-install-recommends apache2 php php-curl php-gd php-mbstring php-xml php-xmlrpc libapache2-mod-php php-mysql php-fpm php-json php-cgi docker.io
sed -i -e '169a\\<Directory /var/www/html/>' /etc/apache2/apache2.conf
sed -i -e '170a\\    AllowOverride All' /etc/apache2/apache2.conf
sed -i -e '171a\\</Directory>' /etc/apache2/apache2.conf
sed -i -e '172a\\' /etc/apache2/apache2.conf
a2enmod rewrite
a2enmod php7.0
apache2ctl configtest

# Wordpress download and configure
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sed -i -e 's/database_name_here/wordpressdb/' /tmp/wordpress/wp-config.php
sed -i -e 's/password_here/Passw.rd/' /tmp/wordpress/wp-config.php
sed -i -e '39a\\define("MYSQL_CLIENT_FLAGS", MYSQLI_CLIENT_SSL);' /tmp/wordpress/wp-config.php

sed -i -e '83a\\' /tmp/wordpress/wp-config.php
sed -i -e '84a\\define("FS_METHOD", "direct");' /tmp/wordpress/wp-config.php
sed -i -e '85a\\define("WP_HOME", "http://". filter_input(INPUT_SERVER, "HTTP_HOST", FILTER_SANITIZE_STRING));' /tmp/wordpress/wp-config.php
sed -i -e '86a\\define("WP_SITEURL", "http://". filter_input(INPUT_SERVER, "HTTP_HOST", FILTER_SANITIZE_STRING));' /tmp/wordpress/wp-config.php
sed -i -e '87a\\define("WP_CONTENT_URL", "/wp-content");' /tmp/wordpress/wp-config.php
sed -i -e '88a\\define("DOMAIN_CURRENT_SITE", filter_input(INPUT_SERVER, "HTTP_HOST", FILTER_SANITIZE_STRING));' /tmp/wordpress/wp-config.php
sed -i -e '89a\\' /tmp/wordpress/wp-config.php
sed -i -e '90a\\' /tmp/wordpress/wp-config.php

# Wordpress cpoy
rm -rf /var/www/html
sudo cp -a /tmp/wordpress/. /var/www/html

chown -R www-data:www-data /var/www/html
chmod -R g+w /var/www/html

# Apache service restart
service apache2 restart

# Docker init
cd ~
curl -O https://raw.githubusercontent.com/krazure/workshop-itpro-101/master/source/Dockerfiles/wpinit/Dockerfile
docker build -t wpinit .

cd /var/www
curl -O https://raw.githubusercontent.com/krazure/workshop-itpro-101/master/source/Dockerfiles/wordpress/Dockerfile