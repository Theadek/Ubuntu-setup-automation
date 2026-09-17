#!/bin/bash


set -euo pipefail

#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

NGINX_CONFIG="/etc/nginx/nginx.conf"

echo "03-nginx-setup starting..."

#install nginx packages
echo "03-nginx-setup: Installing nginx..."
sudo apt-get install -y nginx

#copy myapp.conf file
echo "03-nginx-setup: Copying myapp.conf..."
sudo cp "$scriptDir/../nginx/myapp.conf" "$NGINX_CONFIG"

#test nginx configuration
echo "03-nginx-setup: Testing nginx configuration..."
sudo nginx -t

#enabling nginx service
echo "03-nginx-setup: Enabling nginx service..."
sudo systemctl enable nginx

#start nginx service
echo "03-nginx-setup: Starting nginx service..."
sudo systemctl start nginx

#reload nginx
echo "03-nginx-setup: Reloading nginx service..."
sudo systemctl reload nginx

echo "03-nginx-setup completed"