#!/bin/sh
# Brightness OSD (wob): Usage: brightness.sh up|down
case "$1" in
    up)   ACTION="+5%" ;;
    down) ACTION="5%-" ;;
    *)    exit 1 ;;
esac
brightnessctl -q set "$ACTION"
if command -v wob >/dev/null 2>&1; then
    pct=$(brightnessctl -m | cut -d, -f5)
    printf '%s\n' "$pct" | wob --title brightness -h 34
fi