#!/bin/bash
# Usage on the VM after SSH: sudo bash setup_oracle_vm_complete.sh <git_repo_url>
# This script installs Node.js (v20), git, nginx (optional), pm2, clones your repo (if provided),
# installs npm deps, and helps start the app with pm2.

set -euo pipefail
REPO_URL=${1:-}
APP_DIR="/home/$(whoami)/sepolia_faucet_app"
NODE_VERSION=20

echo "=== Updating system packages ==="
sudo apt-get update && sudo apt-get upgrade -y

echo "=== Install prerequisites ==="
sudo apt-get install -y curl build-essential git nginx

echo "=== Install Node.js ${NODE_VERSION} (NodeSource) ==="
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "=== Install PM2 globally ==="
sudo npm install -g pm2

if [ -n "$REPO_URL" ]; then
  echo "=== Clone repository from $REPO_URL ==="
  # If the directory already exists, skip clone and pull latest
  if [ -d "$APP_DIR" ]; then
    echo "App dir exists; pulling latest"
    cd "$APP_DIR"
    git pull || true
  else
    git clone "$REPO_URL" "$APP_DIR"
  fi
else
  echo "No repo URL provided. Create the app directory at $APP_DIR and upload your code there, then re-run parts of this script manually."
  mkdir -p "$APP_DIR"
fi

cd "$APP_DIR"

if [ -f package.json ]; then
  echo "=== Installing npm dependencies ==="
  npm install --production
else
  echo "Warning: no package.json found in $APP_DIR — make sure you cloned the correct repo."
fi

# Create a basic ecosystem file for pm2 (no secrets here). Do NOT commit this if you add secrets.
cat > ecosystem.config.js <<'PM2CFG'
module.exports = {
  apps: [
    {
      name: 'sepolia-faucet',
      script: './index.js',
      cwd: process.cwd(),
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '200M',
      env_production: {
        NODE_ENV: 'production'
      }
    }
  ]
};
PM2CFG

echo "=== PM2 start: ensure you configure your secrets before starting ==="
cat > README_DEPLOY_NOTES.txt <<'NOTES'
Deployment notes (manual steps you must do before starting):

1) Create a .env file in the app directory ($APP_DIR) with these variables:
   BOT_TOKEN=your_telegram_bot_token
   PRIVATE_KEY=0x...
   RPC_URL=https://sepolia.infura.io/v3/your_key
   DB_PATH=./faucet.db

   Make sure .env is NOT committed to your git repo. Protect it with:
     chmod 600 .env

2) Start the app with pm2 (from $APP_DIR):
     pm2 start ecosystem.config.js --env production
     pm2 save
     sudo pm2 startup systemd
     # Follow the printed instruction from the previous command to run the final
     # command as root (pm2 will print a command you must run once). Example:
     # sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u youruser --hp /home/youruser

3) (Optional) Configure nginx as a reverse proxy for port 80 -> 3000 and enable TLS
   - Create an nginx site file and proxy_pass to http://127.0.0.1:3000
   - Restart nginx: sudo systemctl restart nginx
   - Use certbot to obtain HTTPS certificates if you have a domain.

4) Test the /health endpoint:
   curl -i http://127.0.0.1:3000/health
   # or from outside: curl -i http://<VM_PUBLIC_IP>:3000/health (if port is allowed)

NOTES

echo "=== Starting pm2 process (will fail if .env missing) ==="
if [ -f .env ]; then
  pm2 start ecosystem.config.js --env production || true
  pm2 save || true
  echo "Run 'sudo pm2 startup systemd' and then run the printed command as root to enable startup on reboot."
else
  echo "WARNING: .env not found in $APP_DIR. Create it before starting the app with PM2. See README_DEPLOY_NOTES.txt"
fi

echo "=== Bootstrap script finished ==="
echo "Next: create .env in $APP_DIR, set permissions, then start pm2 as described in README_DEPLOY_NOTES.txt"
