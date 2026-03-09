#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='launcher'

# Три основные опции
CHOICE=$(echo -e "󰀻  Dwindle\n󰉋  Master\n󰕷  Scrolling\n󰉋  Monocle" | \
    rofi -dmenu -theme ${dir}/${theme}.rasi -p "Quick Launch")

case "$CHOICE" in
    "󰀻  Dwindle")
        hyprctl keyword general:layout dwindle &
      ;;
    "󰉋  Master")
        hyprctl keyword general:layout master &  
      ;;
    "󰕷  Scrolling")
        hyprctl keyword general:layout scrolling &
      ;;

    "󰉋  Monocle")
        hyprctl keyword general:layout monocle&
      ;;
    *)
        exit 0
      ;;
esac
