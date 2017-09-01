# Install initial LEMP packages
cd ~
apt-get update
apt-get install nginx
apt-get install -y mysql-server php-fpm php-mysql php-gd php-dom

# Ensure public key available and entered in GitHub
ssh-keygen
echo "Copy the resulting key to your preffered:"
cat ~/.ssh/id_rsa.pub

# Configure default Nginx and PHP settings
git clone git@github.com:alexmdodge/nginx-php-config.git
sudo cp -R ./nginx-php-config/nginx /etc
sudo cp -R ./nginx-php-config/php /etc

# Ensure database settings are secure
mysql_secure_installation

# Get certbot installed for SSL
apt-get update
apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-nginx

echo "When sites added, run the following command:"
echo "sudo certbot --nginx" 
