#!/bin/bash
# Wallpaper picker: $mod+Shift+w
# Opens rofi with image thumbnails of ~/Pictures/wallpapers/* and applies the
# selection with swaybg. The pick is remembered as a SHARED custom wallpaper
# (~/.config/sway-themes/wallpapers/custom.png) used by BOTH light and dark
# themes, so switching themes keeps the same picture.
set -euo pipefail

WP_DIR="$HOME/Pictures/wallpapers"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/wallpaper-power.state"
USER_WP="$HOME/.config/sway-themes/wallpapers"
SHARED_WP="$USER_WP/custom.png"
THUMB_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sway-wallpaper-thumbs"
DEBUG_LOG="${DEBUG_LOG:-${XDG_CACHE_HOME:-$HOME/.cache}/wp-pick.log}"

# Rofi dmenu row icons need REAL separators: NUL between display text and
# fields, \x1f between field name/value:
#     <display>\0icon\x1f/path/to/thumb.jpg
print_log() { echo "$(date +%H:%M:%S) $*" >> "$DEBUG_LOG"; }

make_thumb() {
    local src="$1" dst="$2"
    [ -f "$dst" ] && return 0
    magick "$src" -auto-orient -thumbnail 400x300^ -gravity center -extent 400x300 \
        -quality 82 "$dst" 2>/dev/null || true
}

mkdir -p "$THUMB_DIR" "$USER_WP"
: > "$DEBUG_LOG"

FONTS=()
while IFS= read -r -d '' f; do
    FONTS+=("$(basename "$f")")
done < <(find "$WP_DIR" -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -printf '%f\0' | sort)

[ "${#FONTS[@]}" -eq 0 ] && { notify-send "Fon topilmadi" "$WP_DIR bo'sh" && exit 1; }

for name in "${FONTS[@]}"; do
    make_thumb "$WP_DIR/$name" "$THUMB_DIR/${name%.*}.jpg" || true
done

# Feed rofi directly from a subshell so real NUL/\x1f bytes survive.
# -format i  => print the selected ROW INDEX (0-based), not the text
# -no-custom => only listed entries can be chosen; typed filter + Enter is ignored
pipemenu() {
    for name in "${FONTS[@]}"; do
        thumb="$THUMB_DIR/${name%.*}.jpg"
        [ -f "$thumb" ] || continue
        printf '%b' "${name%.*}\\0icon\\x1f$thumb\\n"
    done
}

idx=$(
  pipemenu | rofi -dmenu -i -p "Fon: " -show-icons -format i -no-custom \
    -theme-str 'window { width: 720px; } listview { lines: 3; columns: 4; fixed-height: 0; }' \
    -theme-str 'element { orientation: vertical; } element-icon { size: 2.5em; }' 2>/dev/null || true
)

print_log "rofi idx => '$idx' (empty = cancel)"

[ -z "$idx" ] && { print_log "cancel"; exit 0; }
case "$idx" in
    *[!0-9]*) print_log "bad idx"; exit 0 ;;
esac

[ "$idx" -ge 0 ] && [ "$idx" -lt "${#FONTS[@]}" ] || { print_log "idx out of range"; exit 0; }

chosen_file="${FONTS[$idx]}"
print_log "chosen_file=$chosen_file shared=$SHARED_WP"

if [ ! -f "$SHARED_WP" ] || ! cmp -s "$WP_DIR/$chosen_file" "$SHARED_WP"; then
    cp "$WP_DIR/$chosen_file" "$SHARED_WP"
    print_log "copied -> $SHARED_WP"
fi

# Clear old per-theme overrides so BOTH themes use the shared picture.
rm -f "$USER_WP"/jetbrains.png "$USER_WP"/jetbrains-light.png 2>/dev/null || true

pkill -x mpvpaper 2>/dev/null || true
pkill -x swaybg 2>/dev/null || true
sleep 0.3

setsid -f swaybg -i "$SHARED_WP" -m fill
print_log "swaybg started"

touch "$STATE_FILE"
[ -s "$STATE_FILE" ] || echo 1 > "$STATE_FILE" 2>/dev/null || true

notify-send "Fon saqlandi (ikkala tema)" "$chosen_file"