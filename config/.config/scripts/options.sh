#!/usr/bin/env bash

CHOICE=$(echo -e "Wallpapers\nThemes\nBar\nLayouts\nDecorations\nSettings" | \
    fuzzel --dmenu )

case "$CHOICE" in
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
