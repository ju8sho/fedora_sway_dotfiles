#!/bin/sh
# Volume OSD (wob): Usage: volume.sh up|down|mute
sink="@DEFAULT_SINK@"
case "$1" in
    up)   pactl set-sink-volume "$sink" +5% ;;
    down) pactl set-sink-volume "$sink" -5% ;;
    mute) pactl set-sink-mute "$sink" toggle ;;
esac

if command -v wob >/dev/null 2>&1; then
    muted=$(pactl get-sink-mute "$sink" | awk '{print $2}')
    vol=$(pactl get-sink-volume "$sink" | awk 'NR==1{print $5}' | tr -d '%')
    [ "$muted" = "yes" ] && vol=0
    printf '%s\n' "$vol" | wob --title volume -h 34
fi