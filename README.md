# Ubuntu Setup Automation

A set of Bash scripts that fully automate provisioning a fresh Ubuntu server: system updates, user accounts, Nginx as a reverse proxy, a UFW firewall, a Node.js/Express backend, and systemd-managed services with automated health checks — all from a single command.

As a demo, the automation deploys a tiny full-stack app: a static page that fetches a random rabbit photo from a public API through the backend.

## What it does

Running `00-main.sh` executes the following steps in order, stopping immediately if any step fails:

| Step | Script                 | Purpose                                                                                                       |
| ---- | ---------------------- | ------------------------------------------------------------------------------------------------------------- |
| 01   | `01-system-setup.sh`   | Updates and upgrades all system packages                                                                      |
| 02   | `02-users-setup.sh`    | Creates a `devops` admin user (sudo) and a `myapp` system user for running the app                            |
| 03   | `03-nginx-setup.sh`    | Installs Nginx, deploys the reverse-proxy config, enables and starts the service                              |
| 04   | `04-firewall-setup.sh` | Installs UFW, allows SSH and HTTP, enables the firewall                                                       |
| 05   | `05-myapp-setup.sh`    | Deploys the frontend and backend files to `/opt/myapp` with correct ownership and permissions                 |
| 06   | `06-nodejs-setup.sh`   | Installs Node.js, installs backend dependencies, sets up the `myapp` systemd service and a health-check timer |
| 07   | `07-verify.sh`         | Verifies UFW, Nginx, and the app are all running and responding correctly                                     |

Every run is logged to a timestamped file in `logs/`.

## Architecture

```
                         Internet
                            |
                            | HTTP :80
                            v
                    +----------------+
                    |     Nginx      |
                    |     :80        |
                    +-------+--------+
                            |
                +-----------+-----------+
                |                       |
             / (static)              /api/*
                |                       |
                v                       v
       /opt/myapp/frontend       Node.js / Express
          index.html                  :3000
                                        |
                                        v
                              External Rabbit API
```

- **Nginx** serves the static frontend directly and proxies `/api/*` requests to the backend.
- **Backend** (Express) exposes `/api/health` and `/api/rabbit` (proxies a public rabbit-image API).
- **systemd** keeps the backend running (`myapp.service`, auto-restart on failure) and runs a health check every minute (`myapp-health.timer` → `myapp-health.service`).
- **UFW** only allows SSH and HTTP traffic.

## Requirements

- A fresh Ubuntu server (tested on Ubuntu 24.04)
- A user with `sudo` privileges
- Internet access (for package installation and the rabbit API demo)

## Usage

```bash
git clone https://github.com/Theadek/Ubuntu-setup-automation.git
cd Ubuntu-setup-automation/scripts
chmod +x *.sh
./00-main.sh
```

The script will prompt for your `sudo` password once at the start. On success, the demo app will be reachable at `http://<server-ip>/`.

## Manual health check

The health check also runs automatically every minute via systemd, but it can be run manually:

```bash
sudo /opt/myapp/scripts/health-check.sh
```

It checks the backend service, Nginx, the `/api/health` endpoint, and disk usage, printing `[OK]`/`[FAIL]` for each.

## Project structure

```
scripts/    Numbered setup scripts, run in order by 00-main.sh
nginx/      Nginx site configuration
services/   systemd unit files (app service + health-check timer)
frontend/   Static demo frontend
backend/    Express backend (Node.js)
logs/       Timestamped setup logs (generated at runtime)
```

## What I'd improve next

- Move hardcoded values (paths, ports, usernames) into a single config file sourced by all scripts
- Add HTTPS via Let's Encrypt/Certbot
- Add health-check logging to file/files

## Tech stack

Bash, Nginx, UFW, systemd, Node.js, Express
