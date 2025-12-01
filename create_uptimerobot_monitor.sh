#!/bin/sh
# Usage: UPTIMEROBOT_API_KEY=<key> MONITOR_URL=<url> sh create_uptimerobot_monitor.sh
if [ -z "$UPTIMEROBOT_API_KEY" ] || [ -z "$MONITOR_URL" ]; then
  echo "Set UPTIMEROBOT_API_KEY and MONITOR_URL environment variables."
  echo "Example: export UPTIMEROBOT_API_KEY=\"<key>\"; export MONITOR_URL=\"https://your-repl.repl.co/health\"; sh create_uptimerobot_monitor.sh"
  exit 1
fi

BODY=$(cat <<JSON
{
  "api_key": "${UPTIMEROBOT_API_KEY}",
  "format": "json",
  "type": 1,
  "friendly_name": "Sepolia Faucet",
  "url": "${MONITOR_URL}",
  "interval": 5
}
JSON
)

curl -s -X POST "https://api.uptimerobot.com/v2/newMonitor" \
  -H "Content-Type: application/json" \
  -d "$BODY"

echo "\n(If the response contains an error, check your API key and URL.)"
