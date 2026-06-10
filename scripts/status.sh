#!/usr/bin/env bash
# Health-check riepilogativo del sistema. Valori d'istanza da vw.conf accanto allo script.
CONF="$(dirname "$0")/vw.conf"
if [ -f "$CONF" ]; then . "$CONF"; fi
: "${VW_HOSTNAME:?}" "${REMOTE:?}"
D="$VW_HOSTNAME"

echo "=== pw-manager health $(date -Is) ==="
echo "--- Container ---"
docker ps --format 'table {{.Names}}\t{{.Status}}'
echo "--- Disco / ---"
df -h /
echo "--- Memoria e swap ---"
free -h
echo "--- Certificato TLS ($D) ---"
echo | openssl s_client -connect 127.0.0.1:443 -servername "$D" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null
echo "--- Risoluzione DNS ---"
getent hosts "$D"
echo "--- Ultimi 3 backup ($REMOTE) ---"
rclone lsl "$REMOTE" 2>/dev/null | sort -k4 | tail -n 3
