#!/usr/bin/env bash
# ==============================================================================
#  ✦ ROFI BLUETOOTH POPUP MENU ✦
# ==============================================================================

THEME="$HOME/.config/rofi/themes/glass.rasi"

# Check bluetooth power state
POWER_STATE=$(bluetoothctl show | grep "Powered: yes" || true)

if [[ -n "$POWER_STATE" ]]; then
    TOGGLE="󰂲  Matikan Bluetooth"
else
    TOGGLE="󰂯  Nyalakan Bluetooth"
fi

# Get paired devices
PAIRED_DEVICES=$(bluetoothctl devices Paired | while read -r _ mac name; do
    CONNECTED=$(bluetoothctl info "$mac" | grep "Connected: yes" || true)
    if [[ -n "$CONNECTED" ]]; then
        echo "🟢 $name [$mac]"
    else
        echo "⚪ $name [$mac]"
    fi
done)

MENU=$(printf '%s\n🔍  Scan Perangkat Baru\n%s\n' "$TOGGLE" "$PAIRED_DEVICES")
CHOSEN=$(printf '%s\n' "$MENU" | rofi -dmenu -i -p "📡 Bluetooth" -theme "$THEME")

[[ -z "$CHOSEN" ]] && exit 0

if [[ "$CHOSEN" == *"Nyalakan Bluetooth"* ]]; then
    bluetoothctl power on
    notify-send "Bluetooth" "Bluetooth aktif"
elif [[ "$CHOSEN" == *"Matikan Bluetooth"* ]]; then
    bluetoothctl power off
    notify-send "Bluetooth" "Bluetooth nonaktif"
elif [[ "$CHOSEN" == *"Scan Perangkat Baru"* ]]; then
    notify-send "Bluetooth" "Memindai perangkat..."
    bluetoothctl --timeout 8 scan on >/dev/null 2>&1
    exec "$0"
elif [[ "$CHOSEN" =~ \[([0-9A-Fa-f:]{17})\] ]]; then
    MAC="${BASH_REMATCH[1]}"
    NAME=$(echo "$CHOSEN" | sed -E 's/^[🟢⚪] //; s/ \[.*//')
    
    if [[ "$CHOSEN" == "🟢"* ]]; then
        notify-send "Bluetooth" "Memutuskan koneksi $NAME..."
        bluetoothctl disconnect "$MAC"
    else
        notify-send "Bluetooth" "Menghubungkan ke $NAME..."
        bluetoothctl connect "$MAC" && notify-send "Bluetooth" "Terhubung ke $NAME" || notify-send -u critical "Bluetooth Error" "Gagal menghubungkan ke $NAME"
    fi
fi
