#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='launcher'

CHOICE=$(echo -e "Night mode Toggle\nTitlebars Toggle\nIdling Toggle" | \
    rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Quick Launch")

case "$CHOICE" in
    "Night mode Toggle")
        bash "$HOME/.config/hypr/scripts/Settings/night-mode.sh"
        ;;
    "Titlebars Toggle")
        bash "$HOME/.config/hypr/scripts/Settings/titlebar_toggle.sh"
        ;;
    "Idling Toggle")
        bash "$HOME/.config/hypr/scripts/Settings/idle.sh"
        ;;
    *)
        exit 0
        ;;
esac
