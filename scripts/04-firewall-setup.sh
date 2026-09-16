#!/bin/bash


echo "04-firewall-setup starting..."

#check sudo authorisation
if ! $(sudo -l &> /dev/null); then
	echo "04-Error: root privilages are needed to run this script"
	echo "$_NOTROOT"
	exit $E_NOTROOT
fi

#install ufw package
if sudo apt-get install -y ufw; then
	echo "04-ufw install completed succesfully"
else
	echo "04-ufw install failed"
	exit 1
fi

#set ufw rule for OpenSSH
if sudo ufw allow OpenSSH; then
	echo "04-ufw allowed OpenSSH succesfully"
else
	echo "04-ufw failed to allow OpenSSH"
	exit 1
fi

#set ufw rule for nginx
if sudo ufw allow 'Nginx HTTP'; then
	echo "04-ufw allowed Nginx succesfully"
else
	echo "04-ufw failed to allow Nginx"
	exit 1
fi

#enable ufw
if sudo ufw --force enable; then
	echo "04-ufw enabled ufw succesfully"
else
	echo "04-ufw failed to enable ufw"
	exit 1
fi
