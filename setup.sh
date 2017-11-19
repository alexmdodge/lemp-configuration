#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                             #
#                         LEMP Setup                          #
#   This config file is a complete LEMP stack installation    #
#   with configuration for base WordPress requirements as     #
#        well as letsencrypt for certificate management       #
#                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Base setup variables including common locations and filepaths
nginx_config="configuration/nginx"
php_config="configuration/nginx"
logrotate_config="configuration/logrotate.d/php7.0-fpm"
index_template="templates/index.php"

# Install essential packages required a common LEMP stack
# Note this may not cover all use cases and extra packages
# may be installed as required.
echo "[LEMP Config] Installing required packages"
apt-get update
apt-get install -y nginx \
  mysql-server \
  php-fpm \
  php-mysql \
  php-gd \
  php-dom

# Copy default configuration and settings
echo "[LEMP Config] Copying base configuration files"
sudo cp -R $nginx_config /etc
sudo cp -R $php_config /etc
sudo cp $index_template /var/www/html

# Create SSL certificates directory
mkdir /etc/nginx/ssl

# Generate a public key
ssh-keygen

# Configure initial directories for logging
mkdir /var/log/php-fpm
touch /var/log/php-fpm/prod_error.log

# Update permissions for the directory
chown -R www-data:$USER /var/log/php-fpm

# Update logrotate configuration
sudo cp $logrotate_config /etc/logrotate.d/php7.0-fpm

# Ensure database settings are secure
mysql_secure_installation

echo "[LEMP Config] Installing letsencrypt"
apt-get update
apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-nginx

echo "[LEMP Config] Checking configuration and restarting services"
sudo nginx -t
sudo service php7.0-fpm restart
sudo service nginx restart

echo "- - - - - - LEMP Configuration Complete - - - - - -"
echo "To initialize a site run the creator script."

# Expose generated public key for authentication uses
echo "Copy the resulting SSH key to nessary locations (GitHub etc.) :"
cat ~/.ssh/id_rsa.pub
echo ""