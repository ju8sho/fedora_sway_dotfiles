#!/usr/bin/env bash
# Bluetooth yoqish/o'chirish tugmasi (waybar right-click).
notify() { notify-send -t 2500 "Bluetooth" "$1"; }

if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    bluetoothctl power off >/dev/null 2>&1
    notify "Bluetooth o'chirildi"
else
    bluetoothctl power on >/dev/null 2>&1
    notify "Bluetooth yoqildi"
fi
pkill -RTMIN+3 waybar 2>/dev/null
