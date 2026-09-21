#!/bin/bash


set -euo pipefail

NVM_VERSION="v0.40.3"
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
BACKEND_DIR="/opt/myapp/backend"

#Installing NVM
echo "06-Installing NVM..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

#Checking Node.js version
echo "06-Node.js version:"
node --version

#Installing npm packages
echo "06-Installing backend dependencies..."
cd $BACKEND_DIR
sudo -u myapp npm ci --prefix /opt/myapp/backend

#Creating service
sudo cp "$scriptDir/../services/myapp.service" /etc/systemd/system/myapp.service

echo "06-Reloading systemd..."
sudo systemctl daemon-reload

echo "06-Enabling and starting myapp service..."
sudo systemctl enable --now myapp.service

echo "06-Checking service status..."
sudo systemctl is-active --quiet myapp.service

echo "06-Node.js setup completed successfully."