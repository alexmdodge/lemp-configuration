# Walks user through connection information

echo "Enter the full public url of the instance: "
read -e url

echo "Enter the local path to the pem key: "
read -e key

echo "Enter the desired output folder: "
read -e output

echo "Enter the username for the destination server"
read -e username

scp -i "$key" lemp-instance-config.tar.gz $username@$url:$output
