#!/bin/bash

# Check if Do Not Disturb is enabled
# This is a placeholder - modify for your specific environment
if [ -f ~/.cache/eww/focus_enabled ]; then
  echo "true"
else
  echo "false"
fi