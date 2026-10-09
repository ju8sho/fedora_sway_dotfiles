#!/usr/bin/env bash
# Bildirishnoma markazi (mako + fuzzel, temaga mos).
#   --get  -> waybar uchun JSON (ikonka + ko'rinayotganlar soni)
#   --show -> tarixni fuzzel da ko'rsatish (power menyu uslubida)

if [ -f "$HOME/.config/waybar/theme.txt" ] && [ "$(cat "$HOME/.config/waybar/theme.txt")" = "light" ]; then
    BG="f7f7f7f2"; TXT="1e1e1fff"; ACC="3b6ea5ff"; SELBG="3b6ea5ee"; SELTXT="f7f7f7ff"
else
    BG="282c34f2"; TXT="abb2bfff"; ACC="61afefff"; SELBG="61afefee"; SELTXT="161618ff"
fi

case "$1" in
  --get)
    python3 -c '
import json, subprocess
try:
    vis = json.loads(subprocess.run(["makoctl", "list", "-j"], capture_output=True, text=True, timeout=5).stdout or "[]")
except Exception:
    vis = []
try:
    hist = json.loads(subprocess.run(["makoctl", "history", "-j"], capture_output=True, text=True, timeout=5).stdout or "[]")
except Exception:
    hist = []
n = len(vis)
if n > 0:
    print(json.dumps({"text": f"🔔 {n}", "class": "unread", "tooltip": f"{n} ta yangi bildirishnoma"}))
else:
    rows = []
    for h in hist[-3:]:
        app = (h.get("app-name") or "").replace("\n", " ")
        summ = (h.get("summary") or "").replace("\n", " ")
        rows.append(f"{app}: {summ}" if app else summ)
    tip = "So\u2018ngilar:\n" + "\n".join(rows) if rows else "Bildirishnomalar (tarix bo\u2018sh)"
    print(json.dumps({"text": "🔔", "class": "empty", "tooltip": tip}))
'
    ;;
  --show)
    # Avval ochiq menyu bo'lsa — yopib chiqamiz (toggle, power menyu kabi).
    for pid in $(pgrep -f "NOTIF-MENU" 2>/dev/null); do
        if [ "$pid" != "$$" ] && [ "$pid" != "$PPID" ]; then
            kill "$pid" 2>/dev/null && closed=1
        fi
    done
    [ "$closed" = 1 ] && exit 0
    pick=$(python3 -c '
import json, subprocess
try:
    hist = json.loads(subprocess.run(["makoctl", "history", "-j"], capture_output=True, text=True, timeout=5).stdout or "[]")
except Exception:
    hist = []
for h in hist[-20:]:
    app = (h.get("app-name") or "").replace("\n", " ")
    summ = (h.get("summary") or "").replace("\n", " ")
    print(f"{app}: {summ}" if app else summ)
' | fuzzel --dmenu --namespace NOTIF-MENU --prompt="🔔 " --lines=10 --width=50 --anchor=top-right --x-margin=8 --y-margin=40 \
    --font="JetBrainsMono Nerd Font:size=11" \
    --background-color="$BG" --text-color="$TXT" --prompt-color="$ACC" --match-color="$ACC" \
    --selection-color="$SELBG" --selection-text-color="$SELTXT" --selection-match-color="$SELTXT" \
    --border-width=2 --border-radius=12 --border-color="$ACC")
    [ -z "$pick" ] && exit 0
    printf "%s" "$pick" | wl-copy
    notify-send -t 1200 "Clipboard" "Bildirishnoma matni nusxalandi"
    ;;
esac
