#!/usr/bin/env bash
# ==============================================================================
#  ✦ ROFI WI-FI POPUP MENU ✦
# ==============================================================================

THEME="$HOME/.config/rofi/themes/glass.rasi"

# Get current wifi status
WIFI_STATUS=$(nmcli -fields WIFI g)

if [[ "$WIFI_STATUS" =~ "disabled" ]]; then
    TOGGLE="󰖩  Nyalakan Wi-Fi"
else
    TOGGLE="󰖪  Matikan Wi-Fi"
fi

# Get list of SSIDs
FIELDS="SSID,SECURITY,BARS"
WIFI_LIST=$(nmcli --fields "$FIELDS" device wifi list --rescan yes | sed 1d | sed -E "s/  +/ /g" | sed -E "s/^ *//" | grep -v "^--" | grep -v "^$" | awk '!seen[$1]++')

CHOSEN=$(printf '%s\n%s\n' "$TOGGLE" "$WIFI_LIST" | rofi -dmenu -i -p "📶 Wi-Fi" -theme "$THEME")

[[ -z "$CHOSEN" ]] && exit 0

if [[ "$CHOSEN" == *"Nyalakan Wi-Fi"* ]]; then
    nmcli radio wifi on
    notify-send "Wi-Fi" "Wi-Fi diaktifkan"
elif [[ "$CHOSEN" == *"Matikan Wi-Fi"* ]]; then
    nmcli radio wifi off
    notify-send "Wi-Fi" "Wi-Fi dinonaktifkan"
else
    SSID=$(echo "$CHOSEN" | awk '{print $1}')
    
    # Check if connection already exists
    KNOWN=$(nmcli -g NAME connection show | grep -Fx "$SSID" || true)
    
    if [[ -n "$KNOWN" ]]; then
        notify-send "Wi-Fi" "Menghubungkan ke $SSID..."
        if nmcli connection up id "$SSID"; then
            notify-send "Wi-Fi" "Terhubung ke $SSID"
        else
            notify-send -u critical "Wi-Fi Error" "Gagal terhubung ke $SSID"
        fi
    else
        SECURITY=$(echo "$CHOSEN" | awk '{print $2}')
        if [[ "$SECURITY" =~ "WPA" || "$SECURITY" =~ "WEP" ]]; then
            PASS=$(rofi -dmenu -password -p "🔑 Password untuk $SSID" -theme "$THEME")
            [[ -z "$PASS" ]] && exit 0
            notify-send "Wi-Fi" "Menghubungkan ke $SSID..."
            if nmcli device wifi connect "$SSID" password "$PASS"; then
                notify-send "Wi-Fi" "Berhasil terhubung ke $SSID"
            else
                notify-send -u critical "Wi-Fi Error" "Password salah atau gagal konek"
            fi
        else
            notify-send "Wi-Fi" "Menghubungkan ke $SSID (Open)..."
            nmcli device wifi connect "$SSID"
        fi
    fi
fi
