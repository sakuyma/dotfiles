#!/bin/bash

LOCK_FILE="/tmp/animations.lock"

if [ -f "$LOCK_FILE" ]; then
    hyprctl keyword animations:enabled yes
    rm -f "$LOCK_FILE"
else
    hyprctl keyword animations:enabled no 
    touch "$LOCK_FILE"
fi
