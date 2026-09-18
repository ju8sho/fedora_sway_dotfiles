#!/usr/bin/env bash
# WiFi yoqish/o'chirish tugmasi (waybar right-click).
notify() { notify-send -t 2500 "WiFi" "$1"; }

if [ "$(nmcli radio wifi)" = "enabled" ]; then
    nmcli radio wifi off
    notify "WiFi o'chirildi"
else
    nmcli radio wifi on
    notify "WiFi yoqildi"
fi
