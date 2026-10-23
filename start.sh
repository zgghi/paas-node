#!/bin/sh
echo "=== EGRESS PROBE ==="
curl -s --max-time 10 https://api.ipify.org; echo
curl -s --max-time 10 "http://ip-api.com/json/?fields=status,country,regionName,city,isp,org,query"; echo
echo "=== PROBE END ==="
UUID="${UUID:-00000000-0000-4000-8000-000000000000}"
MAIN_PORT="${PORT:-8080}"
PORTS="$MAIN_PORT 7860 8080 3000"
INBOUNDS=""
SEEN=""
for p in $PORTS; do
  case " $SEEN " in *" $p "*) continue;; esac
  SEEN="$SEEN $p"
  [ -n "$INBOUNDS" ] && INBOUNDS="$INBOUNDS,"
  INBOUNDS="$INBOUNDS{\"listen\":\"0.0.0.0\",\"port\":$p,\"protocol\":\"vless\",\"settings\":{\"decryption\":\"none\",\"clients\":[{\"id\":\"$UUID\"}]},\"streamSettings\":{\"network\":\"ws\",\"security\":\"none\",\"wsSettings\":{\"path\":\"/\"}}}"
done
printf "%s" "{\"log\":{\"loglevel\":\"warning\"},\"inbounds\":[$INBOUNDS],\"outbounds\":[{\"protocol\":\"freedom\",\"tag\":\"direct\"}]}" > /tmp/config.json
echo "Xray starting on ports: $SEEN"
exec /tmp/xray run -config /tmp/config.json
