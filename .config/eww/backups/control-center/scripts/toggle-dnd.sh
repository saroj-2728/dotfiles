#!/bin/bash

# Simple script to toggle Do Not Disturb mode using swaync

DND_STATUS_FILE=~/.cache/eww/dnd_enabled

# Check current status
if [ -f "$DND_STATUS_FILE" ]; then
  # Disable Do Not Disturb
  rm "$DND_STATUS_FILE"
  swaync-client -D
  notify-send "Do Not Disturb" "Disabled"
else
  # Enable Do Not Disturb
  mkdir -p $(dirname "$DND_STATUS_FILE")
  touch "$DND_STATUS_FILE"
  swaync-client -d
  notify-send "Do Not Disturb" "Enabled"
fi