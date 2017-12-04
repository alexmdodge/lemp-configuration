#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                             #
#                         LEMP Setup                          #
#   This config file is a complete LEMP stack installation    #
#   with configuration for base WordPress requirements as     #
#        well as letsencrypt for certificate management       #
#                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Setup initial user and group structure
sudo usermod -a -G www-data $USER

# Base setup variables including common locations and filepaths
nginx_config="configuration/nginx"
php_config="configuration/php"
logrotate_config="configuration/logrotate.d/php7.0-fpm"
index_template="templates/index.php"

# Install essential packages required a common LEMP stack
# Note this may not cover all use cases and extra packages
# may be installed as required.
printf "[LEMP Config] Installing required packages \n"
sudo apt-get update
sudo apt-get install -y nginx \
  mysql-server \
  php-fpm \
  php-mysql \
  php-gd \
  php-dom

# Ensure database settings are secure
mysql_secure_installation

# Copy default configuration and settings
printf "[LEMP Config] Copying base configuration files \n"
sudo cp -R $nginx_config /etc
sudo cp -R $php_config /etc
sudo rm -R /var/www/html

# Configure initial directories for logging
sudo mkdir /var/log/php-fpm
sudo touch /var/log/php-fpm/prod_error.log

# Update logrotate configuration
sudo cp $logrotate_config /etc/logrotate.d/php7.0-fpm

printf "[LEMP Config] Installing letsencrypt \n"
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx

# Change directories and setup some convenience variables
cd ~
php="php7.0-fpm"
prefix="sudo service"

# Add useful aliases for manipulating server
start="alias lemp-start=\"$prefix nginx start && $prefix $php start\""
stop="alias lemp-stop=\"$prefix nginx stop && $prefix $php stop\""
restart="alias lemp-restart=\"$prefix nginx restart && $prefix $php restart\""
status="alias lemp-status=\"$prefix nginx status && $prefix $php status\""
test="alias lemp-test=\"sudo nginx -t\""

printf "$start \n $stop \n $restart \n $status \n $test \n" >> .bashrc
source ~/.bashrc

# Update all final permissions before restart
sudo chown -R $USER:www-data /var/log/
sudo chown -R $USER:www-data /var/www/
sudo chown -R $USER:www-data /etc/nginx/
sudo chown -R $USER:www-data /etc/php/
sudo chown -R $USER:www-data /etc/logrotate.d/

printf "[LEMP Config] Checking configuration and restarting services \n"
sudo nginx -t
sudo service nginx restart
sudo service php7.0-fpm restart

printf "[LEMP Configuration Complete] To initialize a site run the creator script. \n"