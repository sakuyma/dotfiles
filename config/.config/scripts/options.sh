#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='launcher'

CHOICE=$(echo -e "Wallpapers\nThemes\nBar\nLayouts\nDecorations\nSettings" | \
    rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Quick Launch")

case "$CHOICE" in
    "Wallpapers")
        ~/.config/scripts/wallpaper.sh
        ;;
    "Themes")
        ~/.config/scripts/theme-switcher.sh
        ;;
    "Bar")
        ~/.config/scripts/waybar-switcher.sh
        ;;
    "Layouts")
        ~/.config/scripts/layouts.sh
        ;;
    "Decorations")
       ~/.config/scripts/Decorations.sh 
        ;;

    "Settings")
       ~/.config/scripts/Settings.sh 
        ;;

    *)
        exit 0
        ;;
esac
