#!/bin/bash

# Simple script to get Do Not Disturb status for eww

DND_STATUS_FILE=~/.cache/eww/dnd_enabled

if [ -f "$DND_STATUS_FILE" ]; then
  echo "true"
else
  echo "false"
fi