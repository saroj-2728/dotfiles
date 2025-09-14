#!/bin/bash

# Toggle wlsunset (for Wayland, e.g. Hyprland)

if pgrep -x wlsunset > /dev/null; then
  pkill wlsunset
else
  wlsunset -t 4000 -T 6500 -l 27.7 -L 85.3 &
fi
