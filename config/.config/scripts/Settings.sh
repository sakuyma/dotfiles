#!/usr/bin/env bash

CHOICE=$(echo -e "Night mode Toggle\nTitlebars Toggle\nIdling Toggle" | \
    fuzzel --dmenu )

case "$CHOICE" in
    "Night mode Toggle")
        bash "$HOME/.config/scripts/Settings/night-mode.sh"
        ;;
    "Titlebars Toggle")
        bash "$HOME/.config/scripts/Settings/titlebar_toggle.sh"
        ;;
    "Idling Toggle")
        bash "$HOME/.config/scripts/Settings/idle.sh"
        ;;
    *)
        exit 0
        ;;
esac
