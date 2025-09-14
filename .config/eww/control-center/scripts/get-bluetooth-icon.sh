#!/bin/bash

# Check if Bluetooth is powered on
if bluetoothctl show | grep 'Powered: yes' > /dev/null; then
    # Check if any device is connected
    if bluetoothctl devices Connected | grep 'Device' > /dev/null; then
        echo "󰂱" # Bluetooth connected icon
    else
        echo "󰂯" # Bluetooth on but not connected icon
    fi
else
    echo "󰂲" # Bluetooth off icon
fi