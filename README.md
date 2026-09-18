# Fedora Sway Setup (Rice)

Sway tiling window manager asosidagi ish stoli konfiguratsiyasi.
To'liq oq/qora (light/dark) temalari, waybar panel, rofi menyular, wifi/bluetooth boshqaruvi.

## Tizim komponentlari

| Komponent | Nima qiladi |
|---|---|
| **sway** | Oyna menejeri (tiling) |
| **waybar** | Yuqori panel |
| **rofi** | Menyu / ulanishlar oynasi |
| **kitty** | Asosiy terminal |
| **foot** | Terminal (cursor) |
| **sway-themes** | Tema tizimi (jetbrains, jetbrains-light) |
| **dunst** | Bildirishnomalar (notifications) |
| **swaylock** | Qulflash (lock) ekrani |
| **wlogout** | Chiqish menyusi (power) |
| **gammastep** | Ekran rangini o'zgartirish (night) |

## Tugmalar (Keybinds)

Asosiy tugma: **`$mod` = Super (Windows) tugmasi**

### Oyna boshqaruvi
| Tugma | Vazifa |
|---|---|
| `$mod + Enter` | Terminal (kitty) ochadi |
| `$mod + d` | Rofi menyu (dasturlar) |
| `$mod + Shift + q` | Faol oynani yopish |
| `$mod + Shift + c` | Sway config'ni qayta yuklash |
| `$mod + Shift + e` | Sessiyadan chiqish (swaynag) |
| `$mod + Shift + Space` | Oynani floating qilish |
| `$mod + f` | To'liq ekran (fullscreen) |
| `$mod + Space` | Focus almashtirish (tiled/floating) |
| `$mod + a` | Ota-ona oynaga fokus |

### Focus / harakat
| Tugma | Vazifa |
|---|---|
| `$mod + h/j/k/l` | Fokusni chap/past/yuqori/o'ng (HJKL) |
| `$mod + Shift + h/j/k/l` | Oynani harakatlantirish |
| `$mod + r` | Resize rejimi (`h/j/k/l` = o'lcham, `Esc/Enter` = chiqish) |
| `$mod + b` | Gorizontal split (splith) |
| `$mod + v` | Vertikal split (splitv) |
| `$mod + e` | Layout almashtirish (toggle) |
| `$mod + s` | Stacking layout |
| `$mod + w` | Tabbed layout |
| `$mod + minus` | Scratchpad'ga yuborish |
| `$mod + Shift + minus` | Scratchpad ochish |

### Ish joylari (Workspaces)
| Tugma | Vazifa |
|---|---|
| `$mod + 1..0` | Workspace'ga o'tish (1-10) |
| `$mod + Shift + 1..0` | Oynani workspace'ga ko'chirish |

### Tizim / maxsus
| Tugma | Vazifa |
|---|---|
| `$mod + Shift + w` | Wallpaper tanlash (rofi) |
| `$mod + t` | Tema almashtirish (oq/qora) |
| `XF86AudioRaise/Lower/Mute` | Ovoz balandligi / muheol |
| `XF86MonBrightnessUp/Down` | Yorug'lik |
| `Print` (Select) | Sohil (region) screenshot → clipboard |
| `$mod + Print` | To'liq ekran screenshot → clipboard |
| `Mod4 + ;` (Super+semicolon) | Ekranni qulflash (blur) |
| `Mod4 + l` | Qulflash + uyqu |

## Waybar panel — tugmachalar

| Modul | Chap bosish | O'ng bosish | Scroll |
|---|---|---|---|
| **WiFi** | Rofi wifi menyusi | WiFi on/off | — |
| **Bluetooth** | Rofi qurilmalar menyusi | Bluetooth on/off | — |
| **Yorug'lik** | — | — | Yuqori/past: ko'tar/tushir |
| **Ovoz** | Mute (tinglash) | — | — |
| **Kun/tun (theme)** | Tema almashtirish | — | — |
| **Gammastep** | Rangi o'zgartirish (on/off) | — | — |
| **Quvvat** | Wlogout (chiqish menyusi) | — | — |

WiFi/Bluetooth **menyuda** ham on/off tugmasi bor (ro'yxat boshida).

## Tema tizimi

- Temalar: `~/.config/sway-themes/themes/`
  - `jetbrains` — qorong'u (dark)
  - `jetbrains-light` — yorug' (light)
- Faol tema: `~/.config/sway-themes/current` simlink
- `$mod + t` yoki panel'da theme modulini bosish — oq/qora almashtiradi
- Har bir tema o'z ranglarini beradi: sway (borders), waybar, kitty/foot, rofi, dunst, swaylock

**Yangi tema qo'shish:**
```sh
cp -r ~/.config/sway-themes/themes/jetbrains ~/.config/sway-themes/themes/mening-temam
# so'ng: waybar-colors.css, sway-colors.conf, foot-colors.ini, rofi.rasi ranglarini almashtiring
```

## Klon qilish (yangi mashina)

```sh
git clone git@github.com:ju8sho/dotfiles.git ~/.config
```

Kerakli paketlar: `sway waybar rofi kitty foot dunst swaylock wlogout blueman`
(bluez bluetoothctl/nmcli), `JetBrainsMono Nerd Font`, `mpvpaper/swaybg` (wallpaper).

## Struktura

```
~/.config/
├── sway/            # Sway config, skriptlar
├── waybar/          # Panel (config, style)
├── sway-themes/     # Temalar
├── rofi/            # Menyular
├── kitty/           # Terminal
├── foot/            # Terminal (theme)
├── dunst/           # Bildirishnomalar
├── swaylock/        # Qulflash
├── wlogout/         # Power menyu
├── autostart/       # Avtostart (gammastep)
├── systemd/         # Mask (blueman)
└── starship.toml    # Shell prompt
```