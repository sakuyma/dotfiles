#!/bin/bash

LOCK_FILE="/tmp/rounding.lock"

if [ -f "$LOCK_FILE" ]; then
    hyprctl keyword decoration:rounding 12 
    hyprctl keyword decoration:rounding_power 3 
    rm -f "$LOCK_FILE"
else
    hyprctl keyword decoration:rounding 0 
    hyprctl keyword decoration:rounding_power 0
    touch "$LOCK_FILE"
fi
