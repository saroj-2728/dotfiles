#!/bin/bash
# Lock screen script

# For Hyprland
if pgrep -x "Hyprland" > /dev/null; then
    hyprlock
# For sway
elif pgrep -x "sway" > /dev/null; then
    swaylock
# Fallback
else
    i3lock -c 000000
fi