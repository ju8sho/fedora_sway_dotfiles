#!/usr/bin/env bash
# Bluetooth waybar indicator: holatga qarab \uf293 (on) yoki \uf00b2 (off).
if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    echo '{"text":"\uf00b2","class":"off","tooltip":"Bluetooth o\\u2019chiq\\nChap: menyu, O\\u2019ng: yoqish"}'
else
    n=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
    if [ "$n" -gt 0 ]; then
        echo "{\"text\":\"\uf293\",\"class\":\"on\",\"tooltip\":\"$n qurilma ulangan\\nChap: menyu, O\\u2019ng: o\\u2019chirish\"}"
    else
        echo '{"text":"\uf293","class":"on","tooltip":"Bluetooth yoniq - qurilma yoq\\nChap: menyu, O\\u2019ng: o\\u2019chirish"}'
    fi
fi