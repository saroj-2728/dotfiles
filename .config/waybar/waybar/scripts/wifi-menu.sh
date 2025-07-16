#!/bin/bash

CACHE_FILE="/tmp/wifi_networks_cache"
CACHE_TIMEOUT=15  # Cache timeout in seconds

# Function to get networks and cache them
get_networks() {
    # Get current connection
    CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2)
    
    # Get available networks
    NETWORKS=$(nmcli -t -f ssid,signal,security dev wifi list | sort -t: -k2 -nr | head -10)
    
    # Build menu options
    menu_options=""
    
    # Add current connection status
    if [ -n "$CURRENT_SSID" ]; then
        menu_options+="󰖩 Connected: $CURRENT_SSID\n"
        menu_options+="󰖪 Disconnect\n"
        menu_options+="---\n"
    fi
    
    # Add WiFi toggle
    menu_options+="󰖪 Disable WiFi\n"
    menu_options+="󰑓 Refresh\n"
    menu_options+="---\n"
    
    # Add available networks
    while IFS=: read -r ssid signal security; do
        if [ -n "$ssid" ]; then
            # Choose icon based on signal strength
            if [ "$signal" -gt 75 ]; then
                icon="󰤨"
            elif [ "$signal" -gt 50 ]; then
                icon="󰤥"
            elif [ "$signal" -gt 25 ]; then
                icon="󰤢"
            else
                icon="󰤟"
            fi
            
            # Add security indicator
            if [[ "$security" == *"WPA"* ]] || [[ "$security" == *"WEP"* ]]; then
                security_icon="󰌾"
            else
                security_icon=""
            fi
            
            menu_options+="$icon $ssid $security_icon\n"
        fi
    done <<< "$NETWORKS"
    
    echo -e "$menu_options"
}

# Function to update cache in background
update_cache() {
    get_networks > "$CACHE_FILE.tmp" 2>/dev/null
    mv "$CACHE_FILE.tmp" "$CACHE_FILE" 2>/dev/null
}

# Check if WiFi is enabled
WIFI_STATUS=$(nmcli radio wifi)

if [ "$WIFI_STATUS" = "disabled" ]; then
    # WiFi is disabled, show option to enable
    selected_option=$(echo -e "󰖩 Enable WiFi" | rofi -theme ~/.config/rofi/wifi.rasi -dmenu -i -p "WiFi")
    
    case $selected_option in
        "󰖩 Enable WiFi")
            nmcli radio wifi on
            notify-send "WiFi" "WiFi enabled"
            # Clear cache when enabling WiFi
            rm -f "$CACHE_FILE"
            ;;
    esac
else
    # Check if cache exists and is recent
    if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0))) -lt $CACHE_TIMEOUT ]; then
        # Use cached data and update in background
        menu_options=$(cat "$CACHE_FILE")
        update_cache &
    else
        # Cache is old or doesn't exist, show loading and update
        if [ -f "$CACHE_FILE" ]; then
            # Show old cache immediately
            menu_options=$(cat "$CACHE_FILE")
            update_cache &
        else
            # No cache, show loading message
            echo -e "󰔟 Loading networks..." | rofi -theme ~/.config/rofi/wifi.rasi -dmenu -i -p "WiFi Networks" -no-custom &
            ROFI_PID=$!
            
            # Get networks and kill loading rofi
            menu_options=$(get_networks)
            kill $ROFI_PID 2>/dev/null
            
            # Save to cache
            echo -e "$menu_options" > "$CACHE_FILE"
        fi
    fi
    
    # Show menu
    selected_option=$(echo -e "$menu_options" | rofi -theme ~/.config/rofi/wifi.rasi -dmenu -i -p "WiFi Networks")
    
    # Handle selection
    case $selected_option in
        "󰖪 Disconnect")
            CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2)
            nmcli connection down "$CURRENT_SSID"
            notify-send "WiFi" "Disconnected from $CURRENT_SSID"
            # Clear cache after disconnect
            rm -f "$CACHE_FILE"
            ;;
        "󰖩 Disable WiFi")
            nmcli radio wifi off
            notify-send "WiFi" "WiFi disabled"
            # Clear cache when disabling WiFi
            rm -f "$CACHE_FILE"
            ;;
        "󰑓 Refresh")
            # Force refresh by removing cache
            rm -f "$CACHE_FILE"
            nmcli device wifi rescan &
            exec "$0"
            ;;
        "󰤨 "*|"󰤥 "*|"󰤢 "*|"󰤟 "*)
            # Extract SSID from selection
            SELECTED_SSID=$(echo "$selected_option" | sed 's/^[^ ]* //' | sed 's/ 󰌾$//')
            
            # Check if network requires password
            SECURITY=$(nmcli -t -f ssid,security dev wifi list | grep "^$SELECTED_SSID:" | cut -d: -f2)
            
            if [[ "$SECURITY" == *"WPA"* ]] || [[ "$SECURITY" == *"WEP"* ]]; then
                # Network requires password
                PASSWORD=$(rofi -theme ~/.config/rofi/wifi.rasi -dmenu -password -p "Password for $SELECTED_SSID")
                if [ -n "$PASSWORD" ]; then
                    if nmcli device wifi connect "$SELECTED_SSID" password "$PASSWORD"; then
                        notify-send "WiFi" "Connected to $SELECTED_SSID"
                        # Clear cache after successful connection
                        rm -f "$CACHE_FILE"
                    else
                        notify-send "WiFi" "Failed to connect to $SELECTED_SSID"
                    fi
                fi
            else
                # Open network
                if nmcli device wifi connect "$SELECTED_SSID"; then
                    notify-send "WiFi" "Connected to $SELECTED_SSID"
                    # Clear cache after successful connection
                    rm -f "$CACHE_FILE"
                else
                    notify-send "WiFi" "Failed to connect to $SELECTED_SSID"
                fi
            fi
            ;;
    esac
fi