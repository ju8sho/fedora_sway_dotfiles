#!/usr/bin/env bash
# TLP rejim ko'rsatkichi (waybar custom moduli).
#   --get  -> JSON: BAT/AC + tooltip (profil, manba)
#   --info -> batafsil bildirishnoma

case "$1" in
  --get)
    python3 -c '
import json, subprocess
try:
    out = subprocess.run(["tlp-stat", "-s"], capture_output=True, text=True, timeout=10).stdout
except Exception:
    out = ""
prof, src = "", ""
for line in out.splitlines():
    if "TLP profile" in line:
        prof = line.split("=", 1)[1].strip() if "=" in line else ""
    if "Power source" in line:
        src = line.split("=", 1)[1].strip() if "=" in line else ""
if not prof:
    print(json.dumps({"text": "TLP?", "class": "unknown", "tooltip": "TLP topilmadi"}))
else:
    bat = src.strip().lower() == "battery"
    print(json.dumps({
        "text": "BAT" if bat else "AC",
        "class": "bat" if bat else "ac",
        "tooltip": f"TLP profile: {prof}\nManba: {src}",
    }))
'
    ;;
  --info)
    info=$(tlp-stat -s 2>/dev/null | grep -E "TLP profile|Power source" | tr "\n" " ")
    notify-send -t 3000 "TLP" "${info:-topilmadi}"
    ;;
esac
