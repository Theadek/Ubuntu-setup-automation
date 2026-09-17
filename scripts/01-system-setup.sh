#!/bin/bash


set -euo pipefail

echo "01-system-setup starting..." 

#update and upgrade packages
echo "01-Update packages..."
sudo apt-get update

#upgrade packages without user interaction
echo "01-Upgrade packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q upgrade

echo "01-system-setup completed"

