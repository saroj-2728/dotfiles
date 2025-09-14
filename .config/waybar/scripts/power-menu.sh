#!/bin/bash

# Options
shutdown="󰐥 Shutdown"
reboot="󰜉 Restart"
logout="󰍃 Logout"
lock="󰌾 Lock"
suspend="󰤄 Suspend"
hibernate="󰋊 Hibernate"

# Get answer from user via rofi
selected_option=$(echo -e "$lock\n$logout\n$suspend\n$hibernate\n$reboot\n$shutdown" | rofi -theme ~/.config/rofi/power.rasi -dmenu -i -p "Power Menu")

# Do something based on selected option
case $selected_option in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $logout)
        hyprctl dispatch exit
        ;;
    $lock)
        # Replace with your lock command (swaylock, hyprlock, etc.)
        hyprlock
        ;;
    $suspend)
        systemctl suspend
        ;;
    $hibernate)
        systemctl hibernate
        ;;
esac