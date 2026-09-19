#!/bin/bash


set -euo pipefail

#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

APP_DIR="/opt/myapp"
APP_USER="myapp"

echo "05 - Application setup starting..."

#Create application directory
echo "05: Creating application directory..."
sudo mkdir -p "$APP_DIR/frontend"
sudo mkdir -p "$APP_DIR/backend"

#Copy frontend files
echo "05: Copying frontend..."
sudo cp "$scriptDir/../frontend/index.html" \
    "$APP_DIR/frontend/index.html"

#Copy backend files
echo "05: Copying backend..."
sudo cp "$scriptDir/../backend/server.js" \
    "$APP_DIR/backend/server.js"

sudo cp "$scriptDir/../backend/package.json" \
    "$APP_DIR/backend/package.json"

sudo cp "$scriptDir/../backend/package-lock.json" \
    "$APP_DIR/backend/package-lock.json"

#Set ownership
echo "05: Setting application ownership..."
sudo chown -R "$APP_USER:$APP_USER" "$APP_DIR"

#Set permissions
echo "[INFO] Setting permissions..."
sudo find "$APP_DIR" -type d -exec chmod 755 {} \;
sudo find "$APP_DIR" -type f -exec chmod 644 {} \;

echo "05: Application files deployed successfully."
