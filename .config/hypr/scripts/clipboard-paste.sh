#!/bin/bash
selected=$(cliphist list | rofi -dmenu -p "Clipboard")
[ -z "$selected" ] && exit 0

# Decode and paste directly
echo "$selected" | cliphist decode | wl-copy
wtype -M ctrl -k v