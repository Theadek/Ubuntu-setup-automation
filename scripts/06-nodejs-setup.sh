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

#Creating services
sudo cp "$scriptDir/../services/myapp.service" /etc/systemd/system/myapp.service
sudo cp "$scriptDir/../services/myapp-health.service" /etc/systemd/system/myapp-health.service
sudo cp "$scriptDir/../services/myapp-health.timer" /etc/systemd/system/myapp-health.timer
sudo mkdir -p /opt/myapp/scripts
sudo cp "$scriptDir/health-check.sh" /opt/myapp/scripts/health-check.sh

echo "06-Reloading systemd..."
sudo systemctl daemon-reload

echo "06-Enabling and starting myapp service..."
sudo systemctl enable --now myapp.service

echo "06-Starting myapp-health timer..."
sudo systemctl enable --now myapp-health.timer

echo "06-Node.js setup completed successfully."