#!/bin/bash

CURRENT_STATE=$(hyprctl getoption decoration:blur:enabled | grep -oP 'int: \K\w+')

if [ "$CURRENT_STATE" = "1" ] || [ "$CURRENT_STATE" = "true" ]; then
    hyprctl keyword decoration:blur:enabled false
else
    hyprctl keyword decoration:blur:enabled true
fi
