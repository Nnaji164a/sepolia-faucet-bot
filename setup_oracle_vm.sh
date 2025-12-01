#!/bin/bash
# Usage on the VM after SSH: sudo bash setup_oracle_vm.sh <git_repo_url>
# This script installs Node.js (v20), git, nginx (optional), pm2, clones your repo (if provided),
# installs npm deps, and starts the app with pm2.

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
      cwd: '