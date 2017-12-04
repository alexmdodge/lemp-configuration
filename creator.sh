#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                             #
#                        Site Creator                         #
# A CLI for inputting new site information and creating base  #
# configuration files from the templates. Note that this file #
#  is separate from the creator for ease of adding https to   #
#     other sites which may have been previously set up.      #
#                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo "- - - - - - - - Starting Config Creator - - - - - - - -"

# Get the full domain of new site
echo "Enter the full domain of your new site: "
read -e domain

# Check if www in domain and exit
if [[ $domain == *"www."* ]]; then
    echo "Please enter the domain without the www."
    exit
fi

# Match from the front with % and the back with #
name=$(echo $domain | rev | cut -d"." -f2-  | rev)
root=$(echo $domain | rev | cut -d"." -f1  | rev)

# Set default file nginx location for available and enabled sites
sites_available="/etc/nginx/sites-available"
sites_enabled="/etc/nginx/sites-enabled"

# Confirm domain name and top level
echo "The root of the domain is <$root>, with a first level domain of <$name>"
echo "Is this the domain name correct? (y/n)"
read -e check

# Check if domain correct then replace files
if [ "$check" == y ] ;
then

    # Change the full path domain name settings
    sed "s/{DOMAIN.COM}/$domain/g" templates/domain.conf > $domain.conf.tmp
    sudo mv $domain.conf.tmp $domain.conf

    # Change the partial domain settings (mostly log files)
    sed "s/{DOMAIN}/$name/g" $domain.conf > $domain.conf.tmp
    sudo mv $domain.conf.tmp $domain.conf

    # Move the conf file to the desired location
    sudo mv $domain.conf $sites_available
    sudo cp $sites_available/$domain.conf $sites_available/.$domain.conf-copy

    # Also create site folder in root directory with test page
    sudo mkdir -p /var/www/$domain
    sudo cp templates/index.php /var/www/$domain

    # Enable the site by linking it to the enabled folder
    cd $sites_enabled
    sudo ln -s ../$sites_available/$domain.conf .

    exit
fi

echo "Error: Please run script again and input correct name."
exit