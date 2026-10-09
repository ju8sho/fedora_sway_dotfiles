#!/usr/bin/env bash
# Mango uchun idle-lock (alohida skript: Mango exec dagi quote muammosi bo'lmasligi uchun).
exec swayidle -w \
    timeout 300 '/home/jusho/.local/bin/swaylock -C /home/jusho/.config/swaylock/config -f' \
    before-sleep '/home/jusho/.local/bin/swaylock -C /home/jusho/.config/swaylock/config -f'
