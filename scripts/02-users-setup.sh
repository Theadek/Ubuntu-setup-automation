#!/bin/bash

set -euo pipefail

DEVOPS_USER="devops"
APP_USER="myapp"
APP_DIR="/opt/myapp"

echo "02 - User setup starting..."

# Create administrative user
if id "$DEVOPS_USER" &>/dev/null; then
    echo "02: User $DEVOPS_USER already exists."
else
    echo "02: Creating user $DEVOPS_USER..."
    sudo useradd --create-home --shell /bin/bash "$DEVOPS_USER"
fi

# Add administrative user to sudo group
echo "02: Adding $DEVOPS_USER to sudo group..."
sudo usermod -aG sudo "$DEVOPS_USER"

# Create application user
if id "$APP_USER" &>/dev/null; then
    echo "02: User $APP_USER already exists."
else
    echo "02: Creating application user $APP_USER..."

    sudo useradd \
        --system \
        --no-create-home \
        --shell /usr/sbin/nologin \
        "$APP_USER"
fi

# Create application directory
echo "02: Creating application directory..."
sudo mkdir -p "$APP_DIR"

# Set ownership
echo "02: Setting application ownership..."
sudo chown -R "$APP_USER:$APP_USER" "$APP_DIR"

# Verification
echo "02: Verifying users..."

id "$DEVOPS_USER"
id "$APP_USER"

echo "02: User setup completed successfully."