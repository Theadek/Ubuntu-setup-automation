#!/bin/bash


echo "07 - Verification starting..."

#Checking firewall status
if sudo ufw status | grep -q "Status: active"; then
    echo "[OK] 07-UFW is active."
else
    echo "[ERROR] 07-UFW is not active."
    exit 1
fi

#Checking Nginx service
if sudo systemctl is-active --quiet nginx; then
    echo "[OK] 07-Nginx service is running."
else
    echo "[ERROR] 07-Nginx service is not running."
    exit 1
fi

if curl -fsS http://localhost/ > /dev/null; then
    echo "[OK] 07-Nginx is responding."
else
    echo "[ERROR] 07-Nginx is not responding."
    exit 1
fi

#Checking Node.js application
if sudo systemctl is-active --quiet myapp; then
    echo "[OK] 07-myapp application is running."
else
    echo "[ERROR] 07-myapp application is not running."
    exit 1
fi

#Checking Rabbit API via Nginx reverse proxy
#Waiting for myapp to start might be necessary
for i in {1..10}; do
    if curl -fsS http://localhost/api/rabbit > /dev/null; then
        echo "[OK] 07-Rabbit API request successful."
        break
    fi

    if [ "$i" -eq 10 ]; then
        echo "[ERROR] 07-Rabbit API request failed."
        sudo systemctl status myapp --no-pager
        exit 1
    fi

    sleep 1
done

echo "[OK] 07-All verification checks passed."
