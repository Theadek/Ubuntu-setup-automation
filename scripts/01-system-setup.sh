#!/bin/bash


echo "01-system-setup starting..." 


#update and upgrade packages
if sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q upgrade; then
	echo "01-Update completed succesfully"
	exit 0
else
	echo "01-Update failed"
	exit 1
fi
