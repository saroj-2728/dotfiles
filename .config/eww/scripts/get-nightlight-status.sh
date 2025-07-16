#!/bin/bash

# Check if wlsunset is installed and running
if command -v wlsunset >/dev/null 2>&1; then
  if pgrep -x wlsunset > /dev/null; then
    echo "true"
  else
    echo "false"
  fi
else
  # Default to false if wlsunset is not installed
  echo "false"
fi