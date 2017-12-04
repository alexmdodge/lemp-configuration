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

domain_root="/var/www/$domain"

# Check if domain exists and then build cert
if [ ! -d "$domain_root" ]
then
	printf "$domain directory not found, please try again.\n"
    exit
fi

# Replace the current domains config certs with the newly generated ones
public_cert="/etc/letsencrypt/live/$domain/fullchain.pem"
private_key="/etc/letsencrypt/live/$domain/privkey.pem"

config="/etc/nginx/sites-available/$domain.conf"
temp_config="/etc/nginx/sites-available/$domain.conf.tmp"

sudo certbot certonly --webroot -w $domain_root -d $domain

sed "s|{PUBLIC.CERT}|$public_cert|g" $config > $temp_config
mv $temp_config $config

sed "s|{PRIVATE.KEY}|$private_key|g" $config > $temp_config
mv $temp_config $config

sudo service nginx restart
sudo service php7.0-fpm restart