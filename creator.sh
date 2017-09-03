#!/bin/bash

echo "- - - - - - Starting Config Creator - - - - - - -"

# Get the full domain of new site and copy location
echo "Enter the full domain of your new site: "
read -e domain

# Check copy location
echo "Would like to copy your config to the default? (y/n) :"
echo "/etc/nginx/sites-availiable"
read -e location

# Set default file location flag
isDefault=true

if [ "$location" != y ] ; then
  isDefault=false
  echo "Enter a new location for the conf to be copied: "
  read -e path
  echo "New path set =>  $path"
fi

# Match from the front with % and the back with #
root=${domain#*.}
name=${domain%.*}


# Confirm domain name and top level
echo "The root of the domain is -$root-, with a first level domain of -$name-"
echo "Is this the domain name correct? (y/n)"
read -e check

# Check if domain correct then replace files
if [ "$check" == y ] ; then

  # Change the full path domain name settings
  sed "s/{DOMAIN.COM}/$domain/g" domain-dev.conf > $domain.conf.tmp
  mv $domain.conf.tmp $domain.conf

  # Change the partial domain settings (mostly log files)
  sed "s/{DOMAIN}/$name/g" $domain.conf > $domain.conf.tmp
  mv $domain.conf.tmp $domain.conf

  # Also create site folder in root directory with test page
  sudo mkdir -p /var/www/$domain
  sudo cp templates/index.php /var/www/$domain
  exit
fi

echo "Please run script again and input correct name."
exit