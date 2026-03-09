#!/bin/bash

check_dimmed() {
    if hyprctl getoption decoration:active_opacity | grep -q "float: 1.000000"; then
        return 1
    else
        return 0
    fi
}

FULL_OPACITY="1.0"
DIM_ACTIVE="0.84"
DIM_INACTIVE="0.84"

if check_dimmed; then
    hyprctl keyword decoration:active_opacity $FULL_OPACITY
    hyprctl keyword decoration:inactive_opacity $FULL_OPACITY
    hyprctl keyword decoration:fullscreen_opacity $FULL_OPACITY
else
    hyprctl keyword decoration:active_opacity $DIM_ACTIVE
    hyprctl keyword decoration:inactive_opacity $DIM_INACTIVE
    hyprctl keyword decoration:fullscreen_opacity $FULL_OPACITY
fi
