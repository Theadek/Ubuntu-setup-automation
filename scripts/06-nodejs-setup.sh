#!/bin/bash

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")


set -e

NVM_VERSION="v0.40.3"

echo "Installing NVM..."

curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

export NVM_DIR="$HOME/.nvm"

# Load NVM into the current shell
source "$NVM_DIR/nvm.sh"

echo "Installing Node.js LTS..."

nvm install --lts
nvm alias default 'lts/*'

echo "Node.js version:"
node --version

echo "npm version:"
npm --version

echo "NVM installation complete."




cd "$scriptDir/../backend"
npm ci
nohup node server.js &