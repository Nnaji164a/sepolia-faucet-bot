#!/bin/sh
# Usage: ./test_health.sh [URL]
URL="${1:-http://localhost:3000/health}"

echo "Testing $URL"
curl -i --max-time 10 "$URL"
