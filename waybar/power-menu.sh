#!/usr/bin/env bash
# Power menyu (fuzzel, power tugma tagida). Qayta bossang yopiladi (toggle).
# Ikonlar Nerd Font dan.

# Avval ochiq menyu bo'lsa — yopib chiqamiz (toggle).
for pid in $(pgrep -f "POWER-MENU" 2>/dev/null); do
    if [ "$pid" != "$$" ] && [ "$pid" != "$PPID" ]; then
        kill "$pid" 2>/dev/null && closed=1
    fi
done
[ "$closed" = 1 ] && exit 0

options="  Lock
󰍃  Logout
󰒲  Suspend
󰜗  Hibernate
  Reboot
  Shutdown
  Eye Care
  Theme night/day
  WiFi
  Bluetooth"

# Tema ranglari: theme.txt ga qarab menyu temaga mos ochiladi.
# Launcher (Mod+D) ga tegmaydi — ranglar faqat shu menyuga CLI orqali beriladi.
if [ -f "$HOME/.config/waybar/theme.txt" ] && [ "$(cat "$HOME/.config/waybar/theme.txt")" = "light" ]; then
    BG="f7f7f7f2"; TXT="1e1e1fff"; ACC="3b6ea5ff"; SELBG="3b6ea5ee"; SELTXT="f7f7f7ff"
else
    BG="282c34f2"; TXT="abb2bfff"; ACC="61afefff"; SELBG="61afefee"; SELTXT="161618ff"
fi

choice=$(printf "%s\n" "$options" | fuzzel --dmenu --namespace POWER-MENU --prompt="⏻ " --lines=10 --width=24 --anchor=top-right --x-margin=8 --y-margin=40 \
    --font="JetBrainsMono Nerd Font:size=11" \
    --background-color="$BG" --text-color="$TXT" --prompt-color="$ACC" --match-color="$ACC" \
    --selection-color="$SELBG" --selection-text-color="$SELTXT" --selection-match-color="$SELTXT" \
    --border-width=2 --border-radius=12 --border-color="$ACC")
[ -z "$choice" ] && exit 0

case "$choice" in
    *"Lock"*)
        swaylock -C /home/jusho/.config/swaylock/config -f
        ;;
    *"Logout"*)
        niri msg action quit 2>/dev/null || loginctl terminate-session "${XDG_SESSION_ID:-}"
        ;;
    *"Suspend"*)
        systemctl suspend
        ;;
    *"Hibernate"*)
        systemctl hibernate
        ;;
    *"Reboot"*)
        systemctl reboot
        ;;
    *"Shutdown"*)
        systemctl poweroff
        ;;
    *"Eye Care"*)
        ~/.config/waybar/wlsunset.sh --toggle
        ;;
    *"Theme"*)
        ~/.config/waybar/theme.sh --toggle
        ;;
    *"WiFi"*)
        ~/.config/sway/scripts/wifi-toggle.sh
        ;;
    *"Bluetooth"*)
        ~/.config/sway/scripts/bt-toggle.sh
        ;;
esac
