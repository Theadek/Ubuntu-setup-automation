#!/bin/bash


echo "01-system-setup starting..." 

#check sudo authorisation
if ! $(sudo -l &> /dev/null); then
	echo "01-Error: root privilages are needed to run this script"
	echo "$_NOTROOT"
	return $E_NOTROOT
fi

#update and upgrade packages
if sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q upgrade; then
	echo "01-Update completed succesfully"
	return 0
else
	echo "01-Update failed"
	return 1
fi


