#!/bin/bash


set -euo pipefail

echo "04-firewall-setup starting..."

#install ufw package
echo "04-firewall-setup: Installing ufw..."
sudo apt-get install -y ufw

#set ufw rule for OpenSSH
echo "04-firewall-setup: Setting ufw rule for OpenSSH..."
sudo ufw allow OpenSSH

#set ufw rule for nginx
echo "04-firewall-setup: Setting ufw rule for Nginx..."
sudo ufw allow 'Nginx HTTP'

#enable ufw
echo "04-firewall-setup: Enabling ufw..."
sudo ufw --force enable

#check ufw status
echo "04-firewall-setup: Checking ufw status..."
sudo ufw status

echo "04-firewall-setup completed"