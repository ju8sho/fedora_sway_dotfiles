#!/usr/bin/env bash
# Ekran yozish toggle (wf-recorder + slurp hudud).
# Birinchi bosish: hudud tanlash + yozish boshlanadi. Ikkinchi bosish: to'xtaydi.
OUT_DIR="$HOME/Videos"
mkdir -p "$OUT_DIR"

if pgrep -x wf-recorder >/dev/null; then
    pkill -INT -x wf-recorder
    notify-send -t 2000 "Record" "Yozish to'xtadi, saqlandi: $OUT_DIR"
    exit 0
fi

geo=$(slurp 2>/dev/null) || exit 0
file="$OUT_DIR/Record from $(date '+%Y-%m-%d %H-%M-%S').mp4"
setsid -f wf-recorder -g "$geo" -f "$file" >/dev/null 2>&1
notify-send -t 2000 "Record" "Yozilmoqda... (qayta bosish = stop)"
