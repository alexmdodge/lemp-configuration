# Welcome to REDspace's standardized Nginx and PHP-FPM config
## Check this repo out to your servers etc directory and edit the required files
***

Start by copying the main site config for your sites environment.
For dev environments where you need to configure HTTPS on your local machine:
```sh
$ cp /etc/nginx/sites-availiable/domain-dev.conf /etc/nginx/sites-availiable/your-domain.conf && vi /etc/nginx/sites-availiable/your-domain.conf
```
For any environment where SSL is being terminated at a load balancer, edit this config:
```sh
$ cp /etc/nginx/sites-availiable/domain-aws.conf /etc/nginx/sites-availiable/your-domain.conf && vi /etc/nginx/sites-availiable/your-domain.conf
```

Change where domain is specified in the config file, both for server name and log files.


Finally, link your new config file into the enabled sites config:
```sh
$ cd /etc/nginx/sites-enabled && ln -s ../sites-availiable/your-domain.conf .
```

Edit the following file if you need to add any custom location blocks, to handle specific paths for your site
In general, the standard config will serve standard Drupal and Wordpress sites without much configuration
```sh
$ vi /etc/nginx/includes/custom_paths.conf
```


Create a directory for PHP-FPM to log to and set it's permissions:
```sh
$ mkdir /var/log/php-fpm && chown www-data:adm /var/log/php-fpm
```


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

PHP-FPM might not auto-create the error log for your pool, so just in case:
```sh
$ touch /var/log/php-fpm/prod_error.log && chown www-data:adm /var/log/php-fpm/prod_error.log
```


For local dev or single-instance environments (when a load balancer is not terminating SSL)
Create your SSL certificates for Nginx to use.  First create the directory:
```sh
$ mkdir /etc/nginx/ssl
```


Create the key and certificates:
```sh
$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
```


you'll be asked a number of questions:

        Country Name (2 letter code) [AU]:CA
        State or Province Name (full name) [Some-State]:Nova Scotia
        Locality Name (eg, city) []:Bedford
        Organization Name (eg, company) [Internet Widgits Pty Ltd]:REDspace Inc.
        Organizational Unit Name (eg, section) []:Systems Management
        Common Name (e.g. server FQDN or YOUR name) []:your_domain.com
        Email Address []:admin@your_domain.com



If you want to use letsencrypt, consult letsencrypt docs for it's config if going that route
```sh
$ letsencrypt certonly -a webroot --webroot-path=/var/www/domain.com -d domain.com -d www.domain.com
```

Once the certificates are created, edit the associated sections in your sites conf file from earlier


Test the conf file
```sh
$ nginx -t
```


Restart php-fpm and nginx when ready to launch
```sh
$ service php7.0-fpm restart && service nginx restart
```