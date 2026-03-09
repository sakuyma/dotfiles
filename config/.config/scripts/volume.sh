#!/bin/bash

LOCK_FILE="/tmp/volume_osd.lock"
TIMESTAMP_FILE="/tmp/volume_osd.timestamp"

current_time=$(date +%s)
echo $current_time > $TIMESTAMP_FILE

volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
    get_icons="audio-volume-muted"
    label="  Muted"
else
    if [ $volume -eq 0 ]; then
        get_icons="󰖁 "
        label="󰖁  $volume%"
    elif [ $volume -lt 33 ]; then
        get_icons=" "
        label=" $volume%"
    elif [ $volume -lt 66 ]; then
        get_icons=" "
        label="  $volume%"
    else
        get_icons=" "
        label="  $volume%"
    fi
fi

notify-send -h "int:value:$volume" \
    -h "string:x-canonical-private-synchronous:osd" \
    -u low \
    -i "$get_icons" \
    "Volume" "$label"

(
    sleep 3
    
    last_change=$(cat $TIMESTAMP_FILE 2>/dev/null || echo 0)
    current_time=$(date +%s)
    
    if [ $((current_time - last_change)) -ge 3 ]; then
        notify-send -h "string:x-canonical-private-synchronous:osd" \
                   -u low \
                   -t 1 \
                   " " " "
    fi
) &
