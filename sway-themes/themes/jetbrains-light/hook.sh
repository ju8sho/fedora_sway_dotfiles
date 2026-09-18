#!/bin/sh
# JetBrains Light -> GTK/Kvantum yengil rejimi
gsettings set org.gnome.desktop.interface color-scheme 'default'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
if command -v qt6ct >/dev/null 2>&1; then
  kwriteconfig6 --file qt6ct.conf --group Appearance --key style "kvantum" 2>/dev/null
fi