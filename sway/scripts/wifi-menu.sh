#!/usr/bin/env bash
# WiFi ulanish menyusi — Fedora Sway Spin uslubi.
# Bosganda rofi oynasi ochiladi: topilgan wifi ro'yxati,
# tanlangan tarmoqqa ulanadi (kerak bo'lsa parol so'raydi).

notify() { notify-send -t 3500 "WiFi" "$1"; }

# Joriy ulanish
current="$(nmcli -t -f ACTIVE,SSID connection show --active 2>/dev/null | awk -F: '$1=="yes" {print $2}')"

# Wifi'larni rofi uchun tayyorlaymiz: SSID (signal%) — rescan o'chirilgan,
# chunki `--rescan yes` 4 soniya oladi. NetworkManager o'zi davriy yangilaydi.
networks="$(nmcli -t -f SSID,SIGNAL,BARS device wifi list --rescan no 2>/dev/null | awk -F: 'NF>=2 && $1!="" {printf "%s (%s%%)\n", $1, $2}')"

[ -z "$networks" ] && { notify "Wifi topilmadi — adapterni tekshiring"; exit 0; }

choice="$(printf '%s\n' "$networks" | rofi -dmenu -i -p "WiFi" -theme-str 'window {width: 420px;} listview {lines: 10;}')"
[ -z "$choice" ] && exit 0

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