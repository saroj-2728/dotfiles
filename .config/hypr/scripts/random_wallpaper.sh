#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/backgrounds/"

# Get a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Apply the same wallpaper to all monitors
hyprctl hyprpaper reload ,"$WALLPAPER"