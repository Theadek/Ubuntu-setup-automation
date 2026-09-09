#!/bin/bash


#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

echo "00-Linux server automation started..."

#1 system setup
source "$scriptDir/01-system-setup.sh"
if [ $? -ne 0 ]; then
	echo "Stopping setup"
	exit 1
fi

#2 users


#3 nginx
source "$scriptDir/03-nginx-setup.sh"
if [ $? -ne 0 ]; then
	echo "Stopping setup"
	exit 1
fi

#4 firewall
source "$scriptDir/04-firewall-setup.sh"
if [ $? -ne 0 ]; then
	echo "Stopping setup"
	exit 1
fi

#5 app
source "$scriptDir/05-myapp-setup.sh"
if [ $? -ne 0 ]; then
	echo "Stopping setup"
	exit 1
fi

#6 verify


echo "00-Linux server automation finished succesfully"