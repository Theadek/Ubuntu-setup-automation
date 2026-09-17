#!/bin/bash


#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

echo "03-nginx-setup starting..."


#install nginx packages
if sudo apt-get install -y nginx; then
	echo "03-nginx installed succesfully"
else
	echo "03-nginx installation failed"
	exit 1
fi

#find where is nginx directory
if [ -f "/usr/local/nginx/conf/nginx.conf" ]; then
        nginx_directory="/usr/local/nginx/conf/nginx"
elif [ -f "/etc/nginx/nginx.conf" ]; then
        nginx_directory="/etc/nginx"
elif [ -f "/usr/local/etc/nginx/nginx.conf" ]; then
        nginx_directory="/usr/local/etc/nginx"
fi

#copy myapp.conf file
if sudo cp "$scriptDir/../nginx/myapp.conf" "$nginx_directory/nginx.conf"; then
	echo "03: copied myapp.conf succesfully"
else
	echo "03-Error: couldn't copy myapp.conf"
	exit 1
fi

#reload nginx
if sudo nginx -s reload; then
	echo "03: nginx reloaded succesfully"
else
	echo "03-Error: couldn't reload nginx"
	exit 1
fi
