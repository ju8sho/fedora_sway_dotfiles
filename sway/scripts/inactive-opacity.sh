#!/bin/sh
# Aktiv bo'lmagan oynalarni biroz shaffof qiladi; fokusli oyna solid qoladi.
# Sway IPC socketda uxlaydi — faqat oyna hodisalarida uyg'onadi.
INACTIVE=0.92
LOCK="${XDG_RUNTIME_DIR:-/tmp}/inactive-opacity.lockdir"

# Faqat bitta instance: mkdir atomik — band bo'lsa ikkinchisi chiqib ketadi.
mkdir "$LOCK" 2>/dev/null || exit 0
trap 'rmdir "$LOCK" 2>/dev/null' EXIT INT TERM

apply() {
    swaymsg "[app_id=\".*\"] opacity $INACTIVE; [class=\".*\"] opacity $INACTIVE; [con_id=__focused__] opacity 1" >/dev/null 2>&1
}

apply
swaymsg -t subscribe -m '["window"]' | while read -r event; do
    case "$event" in
        *'"change": "focus"'*|*'"change":"focus"'*|*'"change": "new"'*|*'"change":"new"'*) apply ;;
    esac
done