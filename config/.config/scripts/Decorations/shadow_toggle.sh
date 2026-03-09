#!/bin/bash

LOCK_FILE="/tmp/shadow.lock"

if [ -f "$LOCK_FILE" ]; then
    hyprctl keyword decoration:shadow:enabled true
    rm -f "$LOCK_FILE"
else
    hyprctl keyword decoration:shadow:enabled false 
    touch "$LOCK_FILE"
fi
