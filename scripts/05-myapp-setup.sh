#!/bin/bash


#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

echo "05-myapp setup starting..."

#check sudo authorisation
if ! $(sudo -l &> /dev/null); then
	echo "05-Error: root privilages are needed to run this script"
	echo "$_NOTROOT"
	exit $E_NOTROOT
fi

#check if /opt/myapp directory exist
if [ -d "/opt/myapp" ]; then
	echo "05: /opt/myapp directory exist"
else
	#create /opt/myapp directory
	if sudo mkdir -p /opt/myapp; then
		echo "05: Created /opt/myapp directory"
	else
		echo "05-Error: couldn't create /opt/myapp directory"
		exit 1
	fi
fi

#copy myapp.conf
if sudo cp "$scriptDir/../frontend/index.html" "/opt/myapp/index.html"; then
	echo "05: Copied index.html succesfully"
else
	echo "05-Error: Failed to copy index.html"
	exit 1
fi
