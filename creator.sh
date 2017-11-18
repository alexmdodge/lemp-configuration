#!/bin/bash

##
# A CLI for inputting new site information and creating base
# configuration files from the templates.
##

echo "- - - - - - Starting Config Creator - - - - - - -"

# Get the full domain of new site and copy location
echo "Enter the full domain of your new site: "
read -e domain

# Match from the front with % and the back with #
root=${domain#*.}
name=${domain%.*}

# Set default file location to available and enabled
sites_available="/etc/nginx/sites-available"
sites_enabled="/etc/nginx/sites-enabled"

# Confirm domain name and top level
echo "The root of the domain is <$root>, with a first level domain of <$name>"
echo "Is this the domain name correct? (y/n)"
read -e check

# Check if domain correct then replace files
if [ "$check" == y ] ; then

  # Change the full path domain name settings
  sed "s/{DOMAIN.COM}/$domain/g" templates/domain.conf > $domain.conf.tmp
  mv $domain.conf.tmp $domain.conf

  # Change the partial domain settings (mostly log files)
  sed "s/{DOMAIN}/$name/g" $domain.conf > $domain.conf.tmp
  mv $domain.conf.tmp $domain.conf

  # Move the conf file to the desired location
  sudo mv $domain.conf $sites_available

  # Also create site folder in root directory with test page
  mkdir -p /var/www/$domain
  cp templates/index.php /var/www/$domain

  # Enable the site by moving it to the enabled folder
  cd $sites_enabled
  ln -s ../$sites_available/$domain.conf .

  exit
fi

echo "Please run script again and input correct name."
exit