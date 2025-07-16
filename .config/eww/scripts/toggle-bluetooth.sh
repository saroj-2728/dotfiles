#!/bin/bash

# Check current Bluetooth power state
if bluetoothctl show | grep 'Powered: yes' > /dev/null; then
    # Turn Bluetooth off
    bluetoothctl power off
else
    # Turn Bluetooth on
    bluetoothctl power on
fi