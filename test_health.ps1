param(
  [string]$url = "http://localhost:3000/health"
)

Write-Output "Testing $url"
try {
  $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
  Write-Output "Status: $($resp.StatusCode)"
  Write-Output $resp.Content
} catch {
  Write-Error "Request failed: $_"
}
