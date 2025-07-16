#!/bin/bash

escape() {
    echo "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

max_length=40

status=$(playerctl status 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    icon="󰐊"
elif [[ "$status" == "Paused" ]]; then
    icon="󰏤"
else
    echo "󰎆 No music playing"
    exit
fi

# Create display text
if [[ -n "$artist" && -n "$title" ]]; then
    display_text="$artist - $title"
else
    display_text="$title"
fi

# Truncate if too long
if [[ ${#display_text} -gt $max_length ]]; then
    display_text="${display_text:0:$max_length}..."
fi

# Escape for GTK
display_text=$(escape "$display_text")

echo "$icon $display_text"