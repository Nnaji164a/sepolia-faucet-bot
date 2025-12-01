param(
  [Parameter(Mandatory=$true)][string]$ApiKey,
  [Parameter(Mandatory=$true)][string]$Url
)

$body = @{api_key=$ApiKey; format="json"; type=1; friendly_name="Sepolia Faucet"; url=$Url; interval=5} | ConvertTo-Json

try {
  $resp = Invoke-RestMethod -Uri 'https://api.uptimerobot.com/v2/newMonitor' -Method Post -ContentType 'application/json' -Body $body
  $resp | ConvertTo-Json -Depth 5
} catch {
  Write-Error "Failed to create monitor: $_"
}
