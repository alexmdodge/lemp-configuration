#!/bin/bash

##
# This config file is a complete LEMP stack installation
# with configuration for base WordPress requirements as
# well as letsencrypt for certificate management
##

apt-get update
apt-get install -y nginx \
  mysql-server \
  php-fpm \
  php-mysql \
  php-gd \
  php-dom

# Copy default configuration and settings
echo "- Copying base configuration files"
sudo cp -R configuration/nginx /etc
sudo cp -R configuration/php /etc
sudo cp templates/index.php /var/www/html

# Create SSL certificates directory
mkdir /etc/nginx/ssl

# Configure initial directories for logging
mkdir /var/log/php-fpm
touch /var/log/php-fpm/prod_error.log

# Update permissions for the directory
chown -R www-data:$USER /var/log/php-fpm

# Ensure database settings are secure
mysql_secure_installation

# Get certbot installed for SSL
echo "- Installing letsencrypt"
apt-get update
apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-nginx

# Check configuration and restart services
echo "- Checking configuration and restarting server"
sudo nginx -t
sudo service php7.0-fpm restart
sudo service nginx restart

echo "- - - - - - Instance Configuration Complete - - - - - -"
echo "To setup a site run the creator script, then run certbot to add ssl"
echo "sudo certbot --nginx"

# Ensure public key available and entered in any version
# control system which the instance would require read/write
# access to
ssh-keygen
echo "Copy the resulting SSH key to nessary locations (GitHub etc.) :"
cat ~/.ssh/id_rsa.pub
echo ""