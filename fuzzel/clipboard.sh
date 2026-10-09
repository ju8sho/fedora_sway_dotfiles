#!/usr/bin/env bash
# Clipboard tarixi (cliphist + fuzzel, temaga mos).
# Mod+P dan chaqiriladi. Tanlangan yozuv bufferga nusxalanadi.

if [ -f "$HOME/.config/waybar/theme.txt" ] && [ "$(cat "$HOME/.config/waybar/theme.txt")" = "light" ]; then
    BG="f7f7f7f2"; TXT="1e1e1fff"; ACC="3b6ea5ff"; SELBG="3b6ea5ee"; SELTXT="f7f7f7ff"
else
    BG="282c34f2"; TXT="abb2bfff"; ACC="61afefff"; SELBG="61afefee"; SELTXT="161618ff"
fi

pick=$(cliphist list | fuzzel --dmenu --prompt="clipboard: " --lines=10 --width=50 \
    --background-color="$BG" --text-color="$TXT" --prompt-color="$ACC" --match-color="$ACC" \
    --selection-color="$SELBG" --selection-text-color="$SELTXT" --selection-match-color="$SELTXT" \
    --border-width=2 --border-radius=12 --border-color="$ACC")
[ -z "$pick" ] && exit 0

printf "%s" "$pick" | cliphist decode | wl-copy
notify-send -t 1200 "Clipboard" "Nusxalandi"
