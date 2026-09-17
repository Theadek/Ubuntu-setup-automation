#!/bin/bash


set -euo pipefail

#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

APP_DIR="/opt/myapp"
APP_USER="myapp"

echo "05 - Application setup starting..."

#Create application directory
echo "05: Creating application directory..."
sudo mkdir -p "$APP_DIR"

#Copy application files
echo "05: Copying frontend..."
sudo cp "$scriptDir/../frontend/index.html" "$APP_DIR/index.html"

#Set ownership and permissions
echo "05: Setting application ownership..."
sudo chown -R "$APP_USER:$APP_USER" "$APP_DIR"

#Set permissions for directory - readable and executable by all, writable by owner
echo "05: Setting directory permissions..."
sudo chmod 755 "$APP_DIR"

#Set permissions for index.html - not executable, readable by all, writable by owner
echo "05: Setting file permissions..."
sudo chmod 644 "$APP_DIR/index.html"

echo "05: Application files deployed successfully."
