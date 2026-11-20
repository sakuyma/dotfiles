#!/bin/bash

MON="DP-1"   # ← replace with your real monitor name

if hyprctl monitors -j | grep -q '"name": "'"$MON"'"' && hyprctl monitors -j | grep -q '"disabled": false'; then
    hyprctl keyword monitor "$MON", disable
else
    hyprctl keyword monitor "$MON", preferred, auto, 1
fi
