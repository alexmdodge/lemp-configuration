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

# Ensure public key available and entered in any version
# control system which the instance would require read/write
# access to
ssh-keygen
echo "Copy the resulting key to nessary locations :"
cat ~/.ssh/id_rsa.pub
echo ""

# Copy default configuration and settings
sudo cp -R configuration/nginx-php-config/nginx /etc
sudo cp -R configuration/nginx-php-config/php /etc

# Ensure database settings are secure
mysql_secure_installation

# Get certbot installed for SSL
apt-get update
apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-nginx


echo "- - - - - - - - Instance Configured - - - - - - - -"
echo "To setup a site run the creator script, then run certbot to add ssl"
echo "sudo certbot --nginx"
