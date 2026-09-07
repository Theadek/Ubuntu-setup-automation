#!/bin/bash

echo "03-firewall-setup starting..."

#check sudo authorisation
if ! $(sudo -l &> /dev/null); then
	echo "03-Error: root privilages are needed to run this script"
	echo "$_NOTROOT"
	return $E_NOTROOT
fi

#install ufw package
if sudo apt-get install -y ufw; then
	echo "03-ufw install completed succesfully"
else
	echo "03-ufw install failed"
	return 1
fi

#set ufw rule for OpenSSH
if sudo ufw allow OpenSSH; then
	echo "03-ufw allowed OpenSSH succesfully"
else
	echo "03-ufw failed to allow OpenSSH"
	return 1
fi

#set ufw rule for nginx
if sudo ufw allow 'Nginx HTTP'; then
	echo "03-ufw allowed Nginx succesfully"
else
	echo "03-ufw failed to allow Nginx"
	return 1
fi

#enable ufw
if sudo ufw --force enable; then
	echo "03-ufw enabled ufw succesfully"
else
	echo "03-ufw failed to enable ufw"
	return 1
fi

return 0