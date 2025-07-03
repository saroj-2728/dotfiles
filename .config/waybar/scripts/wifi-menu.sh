#!/bin/bash
# WiFi Menu for Hyprland + Rofi

# Get current connection
current_ssid=$(iwgetid -r)

# Main function
main() {
    nmcli device wifi rescan 2>/dev/null
    
    # Build menu options
    menu_options=""
    
    # Add disconnect option if connected
    if [ -n "$current_ssid" ]; then
        menu_options="󰖪 Disconnect\n"
    fi
    
    # Add refresh option
    menu_options="${menu_options}Refresh Networks\n\n"
    
    # Get WiFi networks with signal strength and format them
    wifi_list=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi list | grep -v '^--' | sort -t: -k3 -nr)
    
    while IFS=: read -r ssid security signal; do
        [ -z "$ssid" ] && continue
        
        # Get signal icon based on strength
        if [ "$signal" -ge 75 ]; then
            signal_icon="󰤨"
        elif [ "$signal" -ge 50 ]; then
            signal_icon="󰤢"
        elif [ "$signal" -ge 25 ]; then
            signal_icon="󰤟"
        else
            signal_icon="󰤯"
        fi
        
        if [[ "$security" != "--" && "$security" != "" ]]; then
            menu_options="${menu_options}$signal_icon $ssid 󰌾\n"
        else
            menu_options="${menu_options}$signal_icon $ssid\n"
        fi
    done <<< "$wifi_list"
    
    # Show rofi menu
    selected=$(echo -e "$menu_options" | rofi -dmenu -i -p "WiFi: " -config ~/.config/rofi/wifi-theme.rasi)
    
    # Handle selection
    case "$selected" in
        "󰖪 Disconnect")
            if [ -n "$current_ssid" ]; then
                nmcli connection down "$current_ssid" 2>/dev/null
            fi
            ;;
        "Refresh Networks")
            exec "$0"
            ;;
        "")
            exit 0
            ;;
        *)
            # Extract SSID (remove signal icon and lock symbol)
            ssid=$(echo "$selected" | sed 's/^[^ ]* //' | sed 's/ 󰌾$//')
            
            if echo "$selected" | grep -q "󰌾"; then
                # Secured network
                if nmcli connection show | grep -qw "$ssid"; then
                    # Profile exists, just connect
		    nmcli connection up "$ssid" >/dev/null 2>&1
                else
                    # No saved profile, ask for password
                    password=$(rofi -dmenu -password -p "Password for $ssid:")
                    if [ -n "$password" ]; then
			nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1
                    fi
                fi
            else
                # Open network
		nmcli device wifi connect "$ssid" >/dev/null 2>&1
            fi
            ;;
    esac
}

# Check dependencies
for cmd in nmcli rofi notify-send iwgetid; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is not installed" >&2
        exit 1
    fi
done

# Run main function
main "$@"
