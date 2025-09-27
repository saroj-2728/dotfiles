#!/bin/bash

# Toggle microphone mute
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

# Check if mic is muted
MIC_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -o "MUTED")

# Control LED and send notification based on mute status
if [ -n "$MIC_MUTED" ]; then
    # Mic is muted - turn on LED
    echo 1 | sudo tee /sys/class/leds/platform::micmute/brightness > /dev/null
    notify-send "Microphone" "Microphone muted" -i microphone-sensitivity-muted -t 2000
else
    # Mic is unmuted - turn off LED
    echo 0 | sudo tee /sys/class/leds/platform::micmute/brightness > /dev/null
    notify-send "Microphone" "Microphone unmuted" -i microphone -t 2000
fi
