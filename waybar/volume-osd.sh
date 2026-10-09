#!/usr/bin/env bash
# Ovoz OSD (mako notify): usage: volume-osd.sh up|down|mute|micmute
TAG="volume-osd"
case "$1" in
    up)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0 ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1- ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    micmute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    *) exit 1 ;;
esac

if [ "$1" = "micmute" ]; then
    info=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)
    notify-send -t 900 -h string:x-canonical-private-synchronous:$TAG "Mikrofon" "$info"
else
    info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    notify-send -t 900 -h string:x-canonical-private-synchronous:$TAG "Ovoz" "$info"
fi
