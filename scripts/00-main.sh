#!/bin/bash


set -euo pipefail

#Get script path
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

#Create a log file with a timestamp
LOG_FILE="$scriptDir/../logs/setup-$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$scriptDir/../logs"
exec > >(tee -a "$LOG_FILE") 2>&1

run_step() {
    local step_name="$1"
    local script="$2"

    echo
    echo "===================="
    echo "$step_name"
    echo "===================="

    if "$script"; then
        echo "[OK] $step_name completed"
    else
        echo "[ERROR] $step_name failed"
        echo "Stopping setup."
        exit 1
    fi
}


if ! sudo -v; then
	echo "00-Error: root privileges are needed to run this script"
	exit 1
fi
echo "00 - Linux server automation started..."

run_step "01 - System setup" "$scriptDir/01-system-setup.sh"
run_step "02 - User setup" "$scriptDir/02-users-setup.sh"
run_step "03 - Nginx setup" "$scriptDir/03-nginx-setup.sh"
run_step "04 - Firewall setup" "$scriptDir/04-firewall-setup.sh"
run_step "05 - Application setup" "$scriptDir/05-myapp-setup.sh"
run_step "06 - Node.js setup" "$scriptDir/06-nodejs-setup.sh"
run_step "07 - Verification" "$scriptDir/07-verify.sh"

echo
echo "===================="
echo "00 - Linux server automation finished"
echo "===================="
