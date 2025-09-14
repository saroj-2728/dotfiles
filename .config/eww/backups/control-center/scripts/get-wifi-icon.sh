#!/bin/bash

STATUS=$(nmcli -t -f STATE g | head -n1)

if [[ "$STATUS" == "connected" ]]; then
    STRENGTH=$(nmcli -f IN-USE,SIGNAL dev wifi | grep "\*" | awk '{print $2}')
    
    if [[ "$STRENGTH" -ge 75 ]]; then
        echo "󰤨"
    elif [[ "$STRENGTH" -ge 50 ]]; then
        echo "󰤥"
    elif [[ "$STRENGTH" -ge 25 ]]; then
        echo "󰤢"
    else
        echo "󰤟"
    fi
else
    echo "󰤭"
fi