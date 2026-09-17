#!/bin/bash


NVM_VERSION="v0.40.3"
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
BACKEND_DIR="$scriptDir/../backend"

#Installing NVM
echo "06-Installing NVM..."
curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

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
npm ci

#Running Node.js application
echo "06-Starting Node.js application..."
nohup node server.js > /dev/null 2>&1 &

echo "06-Node.js setup completed successfully."