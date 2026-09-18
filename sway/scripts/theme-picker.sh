#!/usr/bin/env bash
# Theme tanlash menyusi — rofi orqali barcha mavjud temalarni ko'rsatadi.
# Tanlanganda darhol qo'llaydi (sway-theme <name>).

THEME_BIN="$HOME/.local/bin/sway-theme"

# Active temani aniqlash
active=$(basename "$(readlink "$HOME/.config/sway-themes/current" 2>/dev/null)" 2>/dev/null || true)

# Ro'yxatni tayyorlash: "*" faol tema belgisi
list="$("$THEME_BIN" 2>/dev/null | sed '1d' | sed 's/^  //')"

[ -z "$list" ] && { notify-send -t 2500 "Theme" "Tema topilmadi"; exit 1; }

# Rofi: faol temani oldinga yoki yorqin qilib ko'rsatish
menu="$(printf '%s\n' "$list" | rofi -dmenu -i -p "Theme" -theme-str 'window {width: 400px;} listview {lines: 10;}')"
[ -z "$menu" ] && exit 0

# Tanlangan nominalni ajratib olish (yulduzcha, manba belgisi papera)
name="$(printf '%s' "$menu" | sed 's/^[ *]*//' | awk '{print $1}')"
[ -z "$name" ] && exit 0

"$THEME_BIN" "$name"
notify-send -t 2500 "Theme" "Almashtirildi: $name"