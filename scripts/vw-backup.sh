#!/usr/bin/env bash
# Backup cifrato del database Vaultwarden verso Object Storage.
# I valori d'istanza sono letti da vw.conf (non versionato), accanto a questo script.
set -euo pipefail
export PATH=/usr/local/bin:/usr/bin:/bin
export HOME=/root

CONF="$(dirname "$0")/vw.conf"
if [ ! -f "$CONF" ]; then echo "Config $CONF mancante" >&2; exit 1; fi
# shellcheck disable=SC1090
. "$CONF"
: "${DB:?}" "${AGE_RECIPIENT:?}" "${REMOTE:?}" "${RETENTION_DAYS:?}" "${RCLONE_CONF:?}"

TS="$(date +%Y%m%d-%H%M%S)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

sqlite3 "$DB" ".backup '$TMP/db.sqlite3'"
age -r "$AGE_RECIPIENT" -o "$TMP/vw-$TS.sqlite3.age" "$TMP/db.sqlite3"
rclone --config "$RCLONE_CONF" copy "$TMP/vw-$TS.sqlite3.age" "$REMOTE/"
rclone --config "$RCLONE_CONF" delete --min-age "${RETENTION_DAYS}d" "$REMOTE/"
echo "$(date -Is) backup vw-$TS.sqlite3.age completato"
