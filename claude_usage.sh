#!/usr/bin/env bash
MODE=${1:-all}

if [[ "$MODE" == "all" || "$MODE" == "usage" ]]; then
    CREDENTIALS=~/.claude/.credentials.json
    TOKEN=$(jq -r '.claudeAiOauth.accessToken' "$CREDENTIALS")
    DATA=$(curl -sf -H "Authorization: Bearer $TOKEN" https://api.anthropic.com/api/oauth/usage)
    FIVE_H=$(echo "$DATA" | jq -r '.five_hour.utilization | round | tostring + "%"')
    WEEK=$(echo "$DATA"   | jq -r '.seven_day.utilization  | round | tostring + "%"')
fi

if [[ "$MODE" == "all" || "$MODE" == "status" ]]; then
    STATUS=$(curl -sf --connect-timeout 3 --max-time 5 https://status.claude.com/api/v2/status.json 2>/dev/null | jq -r '.status.indicator // "unknown"' 2>/dev/null)
    STATUS=${STATUS:-unknown}
fi

case "$MODE" in
    usage)  echo "Claude  5h: $FIVE_H  |  7d: $WEEK" ;;
    status) echo "$STATUS" ;;
    *)      echo "Claude  5h: $FIVE_H  |  7d: $WEEK::$STATUS" ;;
esac
