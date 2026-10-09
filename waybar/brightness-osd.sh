#!/usr/bin/env bash
# Yorqinlik OSD (mako notify): usage: brightness-osd.sh up|down
TAG="brightness-osd"
case "$1" in
    up)   brightnessctl --class=backlight set "+10%" >/dev/null ;;
    down) brightnessctl --class=backlight set "10%-" >/dev/null ;;
    *) exit 1 ;;
esac

pct=$(brightnessctl --class=backlight -m 2>/dev/null | cut -d, -f4)
[ -z "$pct" ] && pct=$(brightnessctl --class=backlight get 2>/dev/null)
notify-send -t 900 -h string:x-canonical-private-synchronous:$TAG "Yorqinlik" "$pct"
