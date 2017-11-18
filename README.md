# Base LEMP Stack Configuration and Tooling
This LEMP configuration is designed to simplify the creation of a basic web server
with secure HTTPS as well as other secure features. Primarily intended for
use in an AWS setting, but applicable anywhere. It also comes bundled with a
couple of tools to help with configuring different aspects of the stack.

# Server Setup
First spin up a server instance however you like. You will need access to the
command line. Some shared services do not allow this which is why AWS and Digital Ocean are convenient. SSH into the serve then,

```sh
wget https://github.com/alexmdodge/lemp-instance-config/raw/master/lemp-instance-config.tar.gz
tar -xzf lemp-instance-config.tar.gz
```

This will download and unpack the tar file which contains all of the tooling.

If you would like to edit and re-pack the configuration, or if you're contributing
you can use,

```sh
./build.sh
```
which simply wraps everything up in a new tar ball.

**Note** that once the file is uploaded you may need to set or change permissions
on the scripts. In the `lemp-instance-config` directory you can run the following
commands,

# Setup
Begin by running the server installation script,

```sh
./setup.sh
```
This will configure,
* Nginx
* PHP-FPM
* Default webserver settings
* Install `letsencrypt`
* Prepare server to add individual site instances

# Create
Once you have successfully setup the site you should be able to visit the
public ip address and see a welcome page which has a title and shows information
about the php configuration.

Note that later on once another site is created with public page will be
removed as it is not fit for public facing production instances.

Before you begin make sure you have the domain name setup. This can be done
through any third party, or through Amazon Route 53. To begin the creation
script run,

```sh
./creator.sh
```

This will walk you through all the necessary steps. After the site configuration
is successfully in place

Edit the logrotate script for php-fpm to include the new directory:
```sh     
$ vi /etc/logrotate.d/php7.0-fpm
```
Config should look like:
        
        /var/log/php7.0-fpm.log /var/log/php-fpm/*.log {
                rotate 7
                daily
                missingok
                notifempty
                compress
                create 0750 www-data adm
                delaycompress
                postrotate
                        /usr/lib/php/php7.0-fpm-reopenlogs
                endscript
        }

For local dev or single-instance environments (when a load balancer is not terminating SSL)
