#!/usr/bin/env bash
# ==============================================================================
#  ✦ HYPRLAND SHORTCUT HELPER (ORIGINAL SHELL SYNCED) ✦
# ==============================================================================

THEME="$HOME/.config/rofi/themes/keybinds.rasi"

SHORTCUTS=(
  "🔍  Win + Spasi                  → Buka App Launcher (Rofi)"
  "💻  Win + Enter  /  Win + T      → Buka Terminal (Kitty)"
  "😀  Win + .                      → Pemilih Emoji (Apple-style)"
  "📋  Win + V                      → Riwayat Clipboard"
  "🖼️  Win + W                      → Ganti Wallpaper (Grid + Auto Pywal)"
  "📁  Win + E                      → File Manager (Nautilus)"
  "💻  Win + C                      → Buka VS Code"
  "💡  Win + G                      → Focus Mode (Hilangkan bar & border)"
  "🕶️  Win + Shift + G              → Shader Layar (Night Light / Reading)"
  "⚡  Win + Shift + Enter          → Power Menu"
  "📶  Wi-Fi (CLI)                  → Buka nmtui"
  "📡  Bluetooth (CLI)              → Buka bluetoothctl"
  "❓  Win + /   atau   Win + F1    → Buka Shortcut Helper ini"
  "----------------------------------------------------------------------"
  "❌  Win + Q                      → Tutup Window Aktif"
  "⛶   Win + F                      → Toggle Maximize Window"
  "🖥️  Win + Shift + F              → True Fullscreen"
  "🪟  Win + Shift + T              → Toggle Floating Window"
  "👀  Win + Panah / H J K L        → Pindah Fokus Window"
  "🔄  Win + Shift + Panah / H J K L→ Pindahkan / Tukar Posisi Window"
  "📐  Win + Minus (-) / Equal (=)  → Resize Ukuran Window"
  "🖱️  Win + Klik Kiri (Drag)       → Geser Window Bebas"
  "🖱️  Win + Klik Kanan (Drag)      → Resize Window Bebas"
  "----------------------------------------------------------------------"
  "📑  Win + [1 - 9]                → Pindah ke Workspace 1 s.d. 9"
  "📦  Win + Shift + [1 - 9]        → Pindahkan Window ke Workspace 1 s.d. 9"
  "➡️   Win + Tab / PgDown / U       → Pindah ke Workspace Berikutnya"
  "⬅️   Win + Shift+Tab / PgUp / I   → Pindah ke Workspace Sebelumnya"
  "🔄  Alt + Tab                      → Ganti Fokus Window Berikutnya"
  "🖱️  Win + Scroll Wheel           → Pindah Workspace Cepat"
  "----------------------------------------------------------------------"
  "✂️   Win + Shift + S              → Screenshot Area (ke Clipboard)"
  "📸  Print                        → Screenshot Layar Penuh (ke Clipboard)"
  "🎨  Win + P                      → Color Picker (Hex)"
  "🎥  Alt + R                      → Rekam Layar (wf-recorder)"
  "📊  Win + B                      → Sembunyikan / Tampilkan Waybar"
  "----------------------------------------------------------------------"
  "🔒  Win + Alt + L  /  Alt + L    → Kunci Layar (Hyprlock)"
  "💤  Alt + S                      → Tidurkan Laptop (Suspend + Lock)"
  "🚪  Win + Shift + E  /  Alt + E  → Logout Hyprland"
)

CHOICE=$(printf '%s\n' "${SHORTCUTS[@]}" | rofi -dmenu -i -p "⌨️  Keybinds" -theme "$THEME")

case "$CHOICE" in
  *"App Launcher"*)    rofi -show drun & ;;
  *"Terminal"*)        kitty & ;;
  *"Emoji"*)           rofimoji --action type copy --use-icons & ;;
  *"Clipboard"*)       ~/.config/rofi/scripts/clipboard.sh & ;;
  *"Wallpaper"*)       ~/.config/rofi/scripts/wallpaper-picker.sh & ;;
  *"File Manager"*)    nautilus & ;;
  *"VS Code"*)         code & ;;
  *"Focus Mode"*)      ~/.config/hypr/scripts/focus-mode.sh & ;;
  *"Shader"*)          ~/.config/rofi/scripts/shader-picker.sh & ;;
  *"Power Menu"*)      ~/.config/rofi/scripts/power-menu.sh & ;;
  *"Wi-Fi"*)           kitty -e nmtui & ;;
  *"Bluetooth"*)       kitty -e bluetoothctl & ;;
esac
