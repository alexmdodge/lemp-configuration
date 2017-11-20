#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                             #
#                        Secure Site                          #
#   Uses certbot (letsencrypt) to setup a ssl cert which is   #
#                 copied into the configuration.              #
#                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

flag="$1"
is_subdomain=false

if [ $flag == "--sub-domain"  ]
then
    is_subdomain=true
    printf "[Secure Site] When configuring the site as a subdomain \
            a certificate will not be generated for the default subdomain
            www.
            
            Continue securing as a sub-domain (y/n)?\n"
    read -e use_subdomain

    if [ $use_subdomain != y ]
    then
        printf "[Secure Site] Exiting script."
        exit
    fi
fi

# Get the full domain of site to secure
printf "Enter the full domain of your new site: "
read -e domain

# Check if www in domain and exit
if [[ $domain == *"www."* ]]; then
    printf "Please enter the domain without the www."
    exit
fi

domain_root="/var/www/$domain"

# Check if domain exists and then build cert
if [ ! -d "$domain_root" ]
then
	printf "$domain directory not found, please try again."
    exit
fi

# Only secure the subdomain if flag present
if [ $is_subdomain ]
then
    sudo certbot certonly --webroot -w $domain_root -d $domain
else
    sudo certbot certonly --webroot -w $domain_root -d $domain -d www.$domain
fi

# Replace the current domains config certs with the newly generated ones
config="/etc/nginx/sites-available/$domain.conf"
temp_config="/etc/nginx/sites-available/$domain.conf.tmp"
cert="/etc/letsencrypt/live/$domain"

sed "s/{DOMAIN.CERT}/$cert/g" $config > $temp_config
mv $temp_config $config

sudo service nginx restart
sudo service php7.0-fpm restart