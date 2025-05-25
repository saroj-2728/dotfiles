#!/bin/bash
# Save this as ~/.config/waybar/scripts/bluetooth-toggle.sh

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
else
    bluetoothctl power on
fi