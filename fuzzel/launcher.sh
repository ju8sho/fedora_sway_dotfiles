#!/usr/bin/env bash
# Temaga mos app launcher (Mod+D).
# theme.txt dark/light ga qarab fuzzel ranglarini tanlaydi.

if [ -f "$HOME/.config/waybar/theme.txt" ] && [ "$(cat "$HOME/.config/waybar/theme.txt")" = "light" ]; then
    BG="f7f7f7f2"; TXT="1e1e1fff"; ACC="3b6ea5ff"; SELBG="3b6ea5ee"; SELTXT="f7f7f7ff"
else
    BG="282c34f2"; TXT="abb2bfff"; ACC="61afefff"; SELBG="61afefee"; SELTXT="161618ff"
fi

exec fuzzel --prompt="run: " \
    --background-color="$BG" --text-color="$TXT" --prompt-color="$ACC" --match-color="$ACC" \
    --selection-color="$SELBG" --selection-text-color="$SELTXT" --selection-match-color="$SELTXT" \
    --border-width=2 --border-radius=12 --border-color="$ACC"
