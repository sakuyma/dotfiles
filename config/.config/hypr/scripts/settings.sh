#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='launcher'

CHOICE=$(echo -e "Wallpapers\nThemes\nBar\nLayouts\nDecorations" | \
    rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Quick Launch")

case "$CHOICE" in
    "Wallpapers")
        ~/.config/hypr/scripts/wallpaper.sh
        ;;
    "Themes")
        ~/.config/hypr/scripts/theme-switcher.sh
        ;;
    "Bar")
        ~/.config/hypr/scripts/waybar-switcher.sh
        ;;
    "Layouts")
        ~/.config/hypr/scripts/layouts.sh
        ;;
    "Decorations")
       ~/.config/hypr/scripts/Decorations.sh 
        ;;
    *)
        exit 0
        ;;
esac
