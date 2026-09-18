#!/bin/sh
# Wallpaper: user tanlagan rasm (custom.png) yoki tema rasmini ko'rsatadi.
# Bu skript har 5 soniyada waybar battery.sh tomonidan ham chaqiriladi.
# Ishonchlilik: "swaybg" jarayoni rasmsiz (argumentlarsiz) ishlasa ham,
# u to'g'ri hisoblanmasin — fonda faqat -i ko'rsatilgan rasmlik vame.
#
# Agar output boot'da hali tayyor bo'lmasa, swaybg chiqishi mumkin;
# keyingi chaqiriqda (5s dan keyin) u qayta boshlanadi (self-heal).

THEME_DIR="$HOME/.config/sway-themes/current"
THEME_NAME=$(basename "$(readlink "$THEME_DIR" 2>/dev/null)" 2>/dev/null)

# User wallpapers: custom.png (rofi picker) barcha tema uchun umumiy.
USER_WP="$HOME/.config/sway-themes/wallpapers"

if [ -f "$USER_WP/custom.png" ]; then
    IMAGE="$USER_WP/custom.png"
elif [ -f "$USER_WP/$THEME_NAME.png" ]; then
    IMAGE="$USER_WP/$THEME_NAME.png"
else
    IMAGE="$THEME_DIR/wallpaper-still.png"
fi

# JO'r: faqat -i bilan ishlayotgan swaybg to'g'ri deb hisoblanadi.
running() {
    for p in $(pgrep -x swaybg 2>/dev/null); do
        tr '\0' ' ' < "/proc/$p/cmdline" 2>/dev/null | grep -q " -i " && return 0
    done
    return 1
}

if ! running; then
    pkill -x swaybg 2>/dev/null
    setsid -f swaybg -i "$IMAGE" -m fill
fi