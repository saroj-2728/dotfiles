#!/bin/bash
# Logout script

# For Hyprland
if pgrep -x "Hyprland" > /dev/null; then
    hyprctl dispatch exit
# For sway
elif pgrep -x "sway" > /dev/null; then
    swaymsg exit
# Fallback
else
    pkill -KILL -u $USER
fi