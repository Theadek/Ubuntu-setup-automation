#!/bin/bash


set -u

APP_SERVICE="myapp"
NGINX_SERVICE="nginx"
HEALTH_URL="http://localhost/api/health"
DISK_THRESHOLD=80

FAILED=0

echo "===== Health check $(date) ====="

#Check Node.js service
if systemctl is-active --quiet "$APP_SERVICE"; then
    echo "[OK] myapp service is running."
else
    echo "[FAIL] myapp service is NOT running."
    FAILED=1
fi

#Check Nginx
if systemctl is-active --quiet "$NGINX_SERVICE"; then
    echo "[OK] nginx service is running."
else
    echo "[FAIL] nginx service is NOT running."
    FAILED=1
fi

#Check application HTTP endpoint
if curl -fsS --max-time 5 "$HEALTH_URL" > /dev/null; then
    echo "[OK] Application health endpoint is responding."
else
    echo "[FAIL] Application health endpoint is NOT responding."
    FAILED=1
fi

#Check disk usage
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

if [ "$DISK_USAGE" -lt "$DISK_THRESHOLD" ]; then
    echo "[OK] Disk usage: ${DISK_USAGE}%"
else
    echo "[FAIL] Disk usage: ${DISK_USAGE}%"
    FAILED=1
fi

#Final 
if [ "$FAILED" -eq 0 ]; then
    echo "[OK] All health checks passed."
    exit 0
else
    echo "[FAIL] Health check failed."
    exit 1
fi