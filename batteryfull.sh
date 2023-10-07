#!/bin/bash

export DISPLAY=:0.0
ALREADY_NOTIFIED_LOW=0
ALREADY_NOTIFIED_HIGH=0

while true; do
    battery_percent=$(acpi -b | awk -F, '/Battery/ {print $2+0}' 2>/dev/null)

    if [[ ! "$battery_percent" =~ ^[0-9]+$ ]]; then
        echo "Error: Unable to retrieve battery percentage."
        sleep 300 # (5 minutes)
        continue
    fi
    
    if on_ac_power; then
        if ((battery_percent > 95)) && ((ALREADY_NOTIFIED_HIGH == 0)); then
            notify-send -i "$PWD/batteryfull.png" "Battery Full" "Level: ${battery_percent}% "
            paplay /usr/share/sounds/ubuntu/ringtones/Alarm\ clock.ogg
            ALREADY_NOTIFIED_HIGH=1
        elif ((battery_percent <= 95)); then
            ALREADY_NOTIFIED_HIGH=0
        fi
        ALREADY_NOTIFIED_LOW=0
    else
        if ((battery_percent < 20)) && ((ALREADY_NOTIFIED_LOW == 0)); then
            notify-send -i "$PWD/batteryfull.png" "Battery Low" "Level: ${battery_percent}% "
            paplay /usr/share/sounds/ubuntu/ringtones/Alarm\ clock.ogg
            ALREADY_NOTIFIED_LOW=1
        elif ((battery_percent >= 20)); then
            ALREADY_NOTIFIED_LOW=0
        fi
    fi
    
    sleep 300 # (5 minutes)
done

