#!/usr/bin/env bash
# Bluetooth qurilmalar menyusi — rofi oynasi, wifi-menu uslubida.
# Yaqin/parirovka qilingan qurilmalar ro'yxati, tanlab ulash/o'chirish.

notify() { notify-send -t 2500 "Bluetooth" "$1"; }

# Adapter yoqilganmi
if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    notify "Bluetooth o'chiq — yoqish uchun bluetooth belgisini o'ng tugma bosing"
    exit 0
fi

# Reset agent + qurilmalarni olish (oscilloskopga 2 soniya scan, bloklanishsiz)
(timeout 2 bluetoothctl scan on >/dev/null 2>&1) </dev/null &

# Rofi'ni darhol ochamiz, ma'lum qurilmalar bilan
connected="$(bluetoothctl devices Connected 2>/dev/null)"
paired="$(bluetoothctl devices Paired 2>/dev/null)"

list="$(printf '%s\n' "$connected" "$paired" | awk '{for(i=3;i<=NF;i++){printf "%s\n",$i}}' | awk '!seen[$0]++')"

if [ -z "$list" ]; then
    notify "Qurilmalar qidirilmoqda..."
    sleep 2
    list="$(bluetoothctl devices 2>/dev/null | awk '{for(i=3;i<=NF;i++){printf "%s\n",$i}}' | awk '!seen[$0]++')"
fi

if [ -z "$list" ]; then
    notify "Bluetooth qurilmasi topilmadi"
    exit 0
fi

choice="$(printf '%s\n' "$list" | rofi -dmenu -i -p "Bluetooth" -theme-str 'window {width: 420px;} listview {lines: 10;}')"
[ -z "$choice" ] && exit 0

# Tanlangan qurilmaning MAC manzilini topamiz
mac="$(bluetoothctl devices 2>/dev/null | grep "$choice" | head -1 | awk '{print $2}')"
[ -z "$mac" ] && { notify "Qurilma manzili topilmadi: $choice"; exit 0; }

# Tanlangan qurilma ulanganmi?
if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$mac" >/dev/null 2>&1
    notify "Uzildi: $choice"
else
    bluetoothctl pair "$mac" >/dev/null 2>&1
    if bluetoothctl connect "$mac" >/dev/null 2>&1; then
        notify "Ulanildi: $choice"
    else
        bluetoothctl trust "$mac" >/dev/null 2>&1
        bluetoothctl connect "$mac" >/dev/null 2>&1
        notify "Ulanildi (trust): $choice"
    fi
fi