#!/bin/bash

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '[0-9]+(?=%)' | head -1)
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [[ "$MUTE" == "yes" ]]; then
    echo "󰝟"
elif [[ "$VOLUME" -ge 66 ]]; then
    echo "󰕾"
elif [[ "$VOLUME" -ge 33 ]]; then
    echo "󰖀"
else
    echo "󰕿"
fi
