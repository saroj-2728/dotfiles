#!/bin/bash

# Create the cache directory if it doesn't exist
mkdir -p ~/.cache/eww

# Get the brightness value from the parameter
BRIGHTNESS=$1

# Set the brightness
brightnessctl set ${BRIGHTNESS}%

# Save the current brightness value to a file
echo $BRIGHTNESS > ~/.cache/eww/brightness

# Also handle initial load if needed
if [ ! -f ~/.cache/eww/brightness ]; then
  CURRENT=$(brightnessctl get | awk '{print int($1 * 100 / 255)}')
  echo $CURRENT > ~/.cache/eww/brightness
fi