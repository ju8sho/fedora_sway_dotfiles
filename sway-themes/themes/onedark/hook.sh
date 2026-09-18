#!/bin/sh
# Onedark -> GTK/Kvantum qorong'u rejimi
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
if command -v qt6ct >/dev/null 2>&1; then
  kwriteconfig6 --file qt6ct.conf --group Appearance --key style "kvantum-dark" 2>/dev/null
fi