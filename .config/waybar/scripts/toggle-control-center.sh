#!/bin/bash
# Check if 'control-center' is currently visible
if eww active-windows | grep -q ": control-center"; then
    # It's open, so close both windows
    eww close control-center
    eww close control-center-closer
else
    # It's closed, so open both windows
    eww open control-center-closer
    eww open control-center
fi
