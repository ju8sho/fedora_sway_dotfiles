#!/bin/bash
# Universal kun/tun: butun desktop temasi (sway, waybar, foot, rofi, dunst,
# GTK) bir tugma bilan almashtiriladi. Ko'p ishni sway-theme bajaradi:
# colors, waybar config-active, foot palitra, dunst, wallpaper, hook.sh (GTK).
MODE_FILE="$HOME/.config/waybar/theme.txt"
THEME_BIN="$HOME/.local/bin/sway-theme"

# Waybar jarayonida PATH ~/.local/bin ni o'z ichiga olmaydi (biz u yerdan
# ishlatamiz), shuning uchun uni qo'lda qo'shamiz:
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

apply_mode() {
  local mode="$1"
  echo "$mode" > "$MODE_FILE"
  if [[ "$mode" == "light" ]]; then
    "$THEME_BIN" jetbrains-light
  else
    "$THEME_BIN" jetbrains
  fi
}

toggle_theme() {
  if [[ -f "$MODE_FILE" ]] && [[ "$(cat "$MODE_FILE")" == "light" ]]; then
    apply_mode "dark"
  else
    apply_mode "light"
  fi
  # Niri da swaymsg reload ishlamaydi, waybar ranglarini qo'lda yangilaymiz.
  # (Sway da ham zararsiz — CSS ni qayta o'qiydi.)
  pkill -SIGUSR2 waybar 2>/dev/null || true
}

case "$1" in
  --get)
    if [[ -f "$MODE_FILE" ]] && [[ "$(cat "$MODE_FILE")" == "light" ]]; then
      echo '{"text":"☀","class":"light"}'
    else
      echo '{"text":"🌙","class":"dark"}'
    fi
    ;;
  --toggle)
    toggle_theme
    ;;
  --set-dark)
    apply_mode "dark"
    ;;
  --set-light)
    apply_mode "light"
    ;;
esac