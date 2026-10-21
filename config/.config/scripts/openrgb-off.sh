#!/bin/bash
FLAG="/tmp/openrgb_off"

if [ -f "$FLAG" ]; then
    openrgb --profile "On"
    rm "$FLAG"
else
    openrgb --profile "Off"
    touch "$FLAG"
fi
