#!/bin/bash

escape() {
    echo "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Max characters allowed
max_length=56

status=$(playerctl status 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    icon=""
elif [[ "$status" == "Paused" ]]; then
    icon=""
else
    echo ""
    exit
fi

# Truncate title
if [[ ${#title} -gt $max_length ]]; then
	title="${title:0:$max_length}..."
fi

# Escape the text for GTK
# artist=$(escape "$artist")
title=$(escape "$title")

echo "$icon $title"
