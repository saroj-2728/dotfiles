#!/bin/bash

# Check if Night Light is enabled 
# This uses the GNOME setting, modify for your specific environment (e.g., redshift)
if [ -x "$(command -v gsettings)" ]; then
  # For GNOME
  if gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled | grep "true" > /dev/null; then
    echo "true"
  else
    echo "false"
  fi
elif [ -x "$(command -v redshift)" ]; then
  # For redshift
  if pgrep -x redshift > /dev/null; then
    echo "true"
  else
    echo "false"
  fi
else
  # Default to false if neither is available
  echo "false"
fi