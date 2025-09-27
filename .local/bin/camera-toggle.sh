#!/bin/bash

# Read current LED state to determine camera status
LED_STATE=$(cat /sys/class/leds/asus::camera/brightness 2>/dev/null || echo "0")

if [ "$LED_STATE" = "0" ]; then
    # Camera is currently enabled - DISABLE it
    
    # Block camera access by changing permissions (requires sudo setup)
    sudo chmod 000 /dev/video* 2>/dev/null
    
    # Turn ON LED (indicates camera is disabled/blocked)
    echo 1 | sudo tee /sys/class/leds/asus::camera/brightness > /dev/null
    notify-send "Camera" "Camera disabled and blocked" -i camera-off -t 2000
    
else
    # Camera is currently disabled - ENABLE it
    # Restore camera access permissions
    sudo chmod 666 /dev/video* 2>/dev/null
    
    # Turn OFF LED (indicates camera is available/enabled)
    echo 0 | sudo tee /sys/class/leds/asus::camera/brightness > /dev/null
    notify-send "Camera" "Camera enabled and available" -i camera-on -t 2000
fi
