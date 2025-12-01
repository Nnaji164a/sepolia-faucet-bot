Sepolia Faucet — Replit + UptimeRobot quick setup

What this adds for you
- A `.replit` file to make Replit run `node index.js` automatically when the project is imported or run.
- Small test scripts to validate the `/health` endpoint (PowerShell and sh).
- Optional scripts to create a UptimeRobot monitor using their API (requires your UptimeRobot API key).

Preconditions (what you must do on Replit)
1. Create a new Repl and import this repository (or create a new Repl and upload files).
2. In Replit's Secrets/Environment, set the following env vars (do NOT commit `.env` to git):
   - BOT_TOKEN
   - PRIVATE_KEY
   - RPC_URL
   - (optional) CHAT_ID

Run command
- Replit will use the `.replit` run command which is set to:

  node index.js

This single process runs both the Telegram bot and the /health HTTP endpoint included in `index.js`.

Testing the /health endpoint
- Once the Repl is running, copy its public URL (for example `https://your-repl-name.username.repl.co`). Then test:

PowerShell:

    Invoke-WebRequest -Uri "https://your-repl-name.username.repl.co/health" -UseBasicParsing

bash/curl:

    curl -i https://your-repl-name.username.repl.co/health

You should receive HTTP 200 and a response body `OK`.

Create an UptimeRobot monitor (manual steps)
1. Sign up at https://uptimerobot.com/ and confirm your email.
2. In the dashboard click "Add New Monitor".
   - Monitor Type: HTTP(s)
   - Friendly Name: Sepolia Faucet
   - URL (or IP): https://your-repl-name.username.repl.co/health
   - Monitoring Interval: 5 minutes
3. Save and wait a few minutes. The monitor should report "Up" if the Repl responds.

Create an UptimeRobot monitor (automated using API)
- If you'd rather use the UptimeRobot API, get your API key from: My Settings → API Settings → Main API Key.
- Then you can run the included script `create_uptimerobot_monitor.sh` (Linux/macOS/Git Bash) or `create_uptimerobot_monitor.ps1` (PowerShell) to create the monitor.

Example (bash):

    export UPTIMEROBOT_API_KEY="<your_api_key_here>"
    export MONITOR_URL="https://your-repl-name.username.repl.co/health"
    sh create_uptimerobot_monitor.sh

Example (PowerShell):

    $apiKey = "<your_api_key_here>"
    $url = "https://your-repl-name.username.repl.co/health"
    .\create_uptimerobot_monitor.ps1 -ApiKey $apiKey -Url $url

Security note
- Do not paste your BOT_TOKEN, PRIVATE_KEY, or UPTIMEROBOT_API_KEY in public chat. Keep them in Replit Secrets or a secure place. If you believe any key has been exposed, rotate it immediately.

If you'd like, provide your UptimeRobot API key here (or paste it privately) and I can call the API to create the monitor for you; otherwise run the script above yourself.
