#!/bin/bash

# Toggle Focus/Do Not Disturb mode
# This is a placeholder - modify for your environment

FOCUS_STATUS_FILE=~/.cache/eww/focus_enabled

if [ -f "$FOCUS_STATUS_FILE" ]; then
  # If focus is enabled, disable it
  rm "$FOCUS_STATUS_FILE"
  # Disable Do Not Disturb based on your environment
  if command -v dunstctl &> /dev/null; then
    # For systems using dunst
    dunstctl set-paused false
  elif command -v gsettings &> /dev/null; then
    # For GNOME
    gsettings set org.gnome.desktop.notifications show-banners true
  fi
  notify-send -u critical "Focus Assist" "Focus mode disabled"
else
  # If focus is disabled, enable it
  mkdir -p $(dirname "$FOCUS_STATUS_FILE")
  touch "$FOCUS_STATUS_FILE"
  # Enable Do Not Disturb based on your environment
  if command -v dunstctl &> /dev/null; then
    # For systems using dunst
    dunstctl set-paused true
  elif command -v gsettings &> /dev/null; then
    # For GNOME
    gsettings set org.gnome.desktop.notifications show-banners false
  fi
  notify-send -u critical "Focus Assist" "Focus mode enabled"
fi