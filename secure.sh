#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                             #
#                        Secure Site                          #
#   Uses certbot (letsencrypt) to setup a ssl cert which is   #
#                 copied into the configuration.              #
#                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Get the full domain of site to secure
echo "Enter the full domain of your new site: "
read -e domain

# Check if www in domain and exit
if [[ $domain == *"www."* ]]; then
  echo "Please enter the domain without the www."
  exit
fi

domain_root="/var/www/$domain"

# Check if domain exists and then build cert
if [ ! -d "$domain_root" ]
then
	echo "$domain directory not found, please try again."
    exit
fi

sudo certbot certonly --webroot -w $domain_root -d www.$domain -d $domain

# Replace the current domains config certs with the newly generated ones
config="/etc/nginx/sites-available/$domain.conf"
temp_config="/etc/nginx/sites-available/$domain.conf.tmp"
cert="/etc/letsencrypt/live/$domain"

sed "s/{DOMAIN.CERT}/$cert_location/g" $config > $temp_config
mv $temp_config $config

sudo service nginx restart
sudo service php7.0-fpm restart