#!/bin/bash

# This config file is a complete LEMP stack installation
# with configuration for base WordPress requirements as
# well as letsencrypt for certificate management

# Install initial LEMP packages
cd ~
apt-get update
apt-get install nginx
apt-get install -y mysql-server php-fpm php-mysql php-gd php-dom

# Ensure public key available and entered in GitHub
ssh-keygen
echo "Copy the resulting key to nessary locations:"
cat ~/.ssh/id_rsa.pub

# Configure default Nginx and PHP settings
sudo cp -R ./nginx-php-config/nginx /etc
sudo cp -R ./nginx-php-config/php /etc

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
