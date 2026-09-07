#!/bin/bash


#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

#1 system setup
source "$scriptDir/01-system-setup.sh"
if [ $? -ne 0 ]; then
	echo "Stopping setup"
	exit 1
fi

#2 users
#3 firewall
source "$scriptDir/03-firewall-setup.sh"
if [ $? -ne 0 ]; then
	echo "Stopping setup"
	exit 1
fi

#4 nginx
#5 app
#6 verify