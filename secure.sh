#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                             #
#                        Secure Site                          #
#   Uses certbot (letsencrypt) to setup a ssl cert which is   #
#                 copied into the configuration.              #
#                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Get the full domain of site to secure
printf "Enter the full domain of your new site: \n"
read -e domain

# Match from the front with % and the back with #
name=$(echo $domain | rev | cut -d"." -f2-  | rev)

# Check if domain exists and then build cert
if [ ! -d "/var/www/$domain" ]
then
	printf "$domain directory not found, please try again.\n"
    exit
fi

sudo service nginx stop
sudo service php7.0-fpm stop

# Replace the current domains config certs with the newly generated ones
public_cert="/etc/letsencrypt/live/$domain/fullchain.pem"
private_key="/etc/letsencrypt/live/$domain/privkey.pem"

# Common file locations
sites_available="/etc/nginx/sites-available"
sites_enabled="/etc/nginx/sites-enabled"

# Simplify template naming
template="templates/domain.secure.conf"
temp_conf="$domain.conf.tmp"
conf="$domain.conf"

sudo certbot --nginx

# Setup public and private ssl certs in new configuration
sed "s|{PUBLIC.CERT}|$public_cert|g" $template > $temp_conf
sudo mv $temp_conf $conf

sed "s|{PRIVATE.KEY}|$private_key|g" $conf > $temp_conf
sudo mv $temp_conf $conf

# Change the full path domain name settings
sed "s/{DOMAIN.COM}/$domain/g" $conf > $temp_conf
sudo mv $temp_conf $conf

# Change the partial domain settings (mostly log files)
sed "s/{DOMAIN}/$name/g" $conf > $temp_conf
sudo mv $temp_conf $conf

# Move the conf file to the desired location
sudo rm $sites_available/$conf
sudo rm $sites_available/.$conf-copy

sudo mv $conf $sites_available
sudo cp $sites_available/$conf $sites_available/.$conf-copy
sudo cp $sites_available/$conf $sites_enabled/$conf

sudo service nginx start
sudo service php7.0-fpm start