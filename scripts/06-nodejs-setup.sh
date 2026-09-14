#!/bin/bash


NVM_VERSION="v0.40.3"
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

#Installing NVM
if curl "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash; then
    echo "06-NVM installed successfully"
else
    echo "06-Error: Failed to install NVM"
    return 1
fi

#Reloading nvm after installation
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

#Installing Node.js LTS
if nvm install --lts; then
    echo "06-Node.js LTS installed successfully"
else
    echo "06-Error: Failed to install Node.js LTS"
    return 1
fi
nvm alias default 'lts/*'

#Installing npm packages
cd "$scriptDir/../backend"
if npm ci; then
    echo "06-JS packages installed successfully"
else
    echo "06-Error: Failed to install JS packages"
    return 1
fi

#Starting Node.js server
echo "06-Starting node server..."
nohup node server.js &

return 0