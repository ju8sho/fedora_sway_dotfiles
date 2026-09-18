#!/usr/bin/env bash
# WiFi ulanish menyusi — Fedora Sway Spin uslubi.
# Bosganda rofi oynasi ochiladi: topilgan wifi ro'yxati,
# tanlangan tarmoqqa ulanadi (kerak bo'lsa parol so'raydi).

notify() { notify-send -t 3500 "WiFi" "$1"; }

# Joriy ulanish
current="$(nmcli -t -f ACTIVE,SSID connection show --active 2>/dev/null | awk -F: '$1=="yes" {print $2}')"

# Wifi radio holati
radio="$(nmcli radio wifi 2>/dev/null)"

# Wifi'larni rofi uchun tayyorlaymiz: SSID (signal%) — rescan o'chirilgan,
# chunki `--rescan yes` 4 soniya oladi. NetworkManager o'zi davriy yangilaydi.
networks="$(nmcli -t -f SSID,SIGNAL,BARS device wifi list --rescan no 2>/dev/null | awk -F: 'NF>=2 && $1!="" {printf "%s (%s%%)\n", $1, $2}')"

# On/off tugmasi ro'yxat boshida (rofi birinchi qator sifatida ko'rsatadi)
if [ "$radio" = "enabled" ]; then
    toggle_item="WiFi o'chirish — hozir yoqilgan"
else
    toggle_item="WiFi yoqish — hozir o'chiq"
fi

if [ "$radio" = "disabled" ]; then
    choice="$(printf '%s\n' "$toggle_item" | rofi -dmenu -i -p "WiFi" -theme-str 'window {width: 420px;} listview {lines: 10;}')"
    [ -z "$choice" ] && exit 0
    if [ "$choice" = "$toggle_item" ]; then
        nmcli radio wifi on
        notify "WiFi yoqildi"
        # Radio yoqilgach rofi'ni yopish va qayta ulanishni tugatish
        sleep 1
        exec "$0"
    fi
    exit 0
fi

menu="$(printf '%s\n' "$toggle_item" "" "$networks")"
choice="$(printf '%s\n' "$menu" | rofi -dmenu -i -p "WiFi" -theme-str 'window {width: 420px;} listview {lines: 10;}')"
[ -z "$choice" ] && exit 0

if [ "$choice" = "$toggle_item" ]; then
    nmcli radio wifi off
    notify "WiFi o'chirildi"
    exit 0
fi

ssid="${choice% (*}"
ssid="$(printf '%s' "$ssid" | sed 's/%/\\x25/g')"
printf -v ssid '%b' "$ssid"

if [ "$ssid" = "$current" ]; then
    notify "Ushbu tarmoqqa allaqachon ulangansiz: $ssid"
    exit 0
fi

# Tarmoq ma'lum parol kerakmi yoki ochiqmi
nmcli -t -f SSID,SECURITY device wifi list 2>/dev/null | grep -qi "^$ssid:\(WPA\|WEP\)"
if echo "$ssid" | nmcli device wifi connect "$ssid" 2>&1; then
    notify "Ulanildi: $ssid"
else
    # Parol so'raymiz (rofi oyna)
    pass="$(rofi -dmenu -p "Parol: $ssid" -password -theme-str 'window {width: 420px;}')"
    [ -z "$pass" ] && exit 0
    if nmcli device wifi connect "$ssid" password "$pass" 2>&1; then
        notify "Ulanildi: $ssid"
    else
        notify "Ulanib bo'lmadi: $ssid (noto'g'ri parol?)"
    fi
fi