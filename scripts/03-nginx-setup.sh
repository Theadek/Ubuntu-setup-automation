#!/bin/bash


#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

echo "03-nginx-setup starting..."

#check sudo authorisation
if ! $(sudo -l &> /dev/null); then
	echo "03-Error: root privilages are needed to run this script"
	echo "$_NOTROOT"
	return $E_NOTROOT
fi

#install nginx packages
if sudo apt-get install -y nginx; then
	echo "03-nginx installed succesfully"
else
	echo "03-nginx installation failed"
	return 1
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
if sudo cp "$scriptDir/../nginx/myapp.conf" "$nginx_directory/myapp.conf"; then
	echo "03: copied myapp.conf succesfully"
else
	echo "03-Error: couldn't copy myapp.conf"
	return 1
fi

#reload nginx
if sudo nginx -s reload; then
	echo "03: nginx reloaded succesfully"
else
	echo "03-Error: couldn't reload nginx"
	return 1
fi

return 0