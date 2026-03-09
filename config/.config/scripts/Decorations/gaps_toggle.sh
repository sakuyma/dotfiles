#!/bin/bash

LOCK_FILE="/tmp/gaps.lock"

if [ -f "$LOCK_FILE" ]; then
    hyprctl keyword general:gaps_in 5
    hyprctl keyword general:gaps_out 20
    rm -f "$LOCK_FILE"
else
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0 
    touch "$LOCK_FILE"
fi
