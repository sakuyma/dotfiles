#!/usr/bin/env bash


CHOICE=$(echo -e "Dwindle\nMaster\nScrolling\nMonocle" | \
    fuzzel --dmenu )

case "$CHOICE" in
    "Dwindle")
        hyprctl keyword general:layout dwindle &
        ;;
    "Master")
        hyprctl keyword general:layout master &  
        ;;
    "Scrolling")
        hyprctl keyword general:layout scrolling &
        ;;
    "Monocle")
        hyprctl keyword general:layout monocle &
        ;;
    *)
        exit 0
        ;;
esac
