#!/bin/bash


NVM_VERSION="v0.40.3"
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
BACKEND_DIR="/opt/myapp/backend"

#Installing NVM
echo "06-Installing NVM..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

#Reloading nvm after installation
echo "06-Reloading NVM..."
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

#Installing Node.js LTS
echo "06-Installing Node.js LTS..."
nvm install --lts
nvm alias default 'lts/*'

echo "06-Node.js version:"
node --version

echo "06-Nvm version:"
nvm --version

#Installing npm packages
echo "06-Installing backend dependencies..."
cd $BACKEND_DIR
sudo npm ci --prefix /opt/myapp/backend

#Creating service
sudo cp "$scriptDir/../services/myapp.service" /etc/systemd/system/myapp.service

echo "06-Reloading systemd..."
sudo systemctl daemon-reload

echo "06-Enabling and starting myapp service..."
sudo systemctl enable --now myapp.service

echo "06-Checking service status..."
sudo systemctl is-active --quiet myapp.service

echo "06-Node.js setup completed successfully."