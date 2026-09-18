#!/bin/bash
# Waybar module: eye protection (wlsunset) on/off toggle.
#   --get     -> JSON for the bar ({icon, class, tooltip})
#   --toggle  -> enable/disable wlsunset for the current session only
# State file holds wlsunset's PID when running, "off" otherwise.
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/wlsunset.toggle"

running_pid() {
    pgrep -x wlsunset | head -1
}

get_state() {
    local pid
    pid=$(running_pid)
    if [ -n "$pid" ]; then
        echo "$pid" > "$STATE_FILE"
        echo '{"text":"\uf12a","class":"on","alt":"on","tooltip":"Ko\\u2019z himoyasi: YONIQ (kun botishi bo\\u2019yicha)"}'
    else
        echo '{"text":"\uf12b","class":"off","alt":"off","tooltip":"Ko\\u2019z himoyasi: O\\u2019CHIQ"}'
    fi
}

enable() {
    pkill -x wlsunset 2>/dev/null
    sleep 0.3
    nohup wlsunset -l 41.31 -L 69.24 -t 4000 -T 6500 >/dev/null 2>&1 &
    disown || true
}

disable() {
    pkill -x wlsunset 2>/dev/null
}

case "$1" in
    --toggle)
        if [ -n "$(running_pid)" ]; then
            disable
        else
            enable
        fi
        sleep 0.5
        ;;
    --enable)
        enable
        sleep 0.5
        ;;
    --disable)
        disable
        ;;
esac
get_state