#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='launcher'

CHOICE=$(echo -e "Blur Toggle\nGaps Toggle\nOpacity Toggle\nShadow Toggle\nRounding Toggle" | \
    rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Quick Launch")

case "$CHOICE" in
    "Blur Toggle")
        bash "$HOME/.config/hypr/scripts/Decorations/blur_toggle.sh"
        ;;
    "Gaps Toggle")
        bash ~/.config/hypr/scripts/Decorations/gaps_toggle.sh
        ;;
    "Opacity Toggle")
        bash "$HOME/.config/hypr/scripts/Decorations/opacity_toggle.sh"
        ;;
    "Shadow Toggle")
        bash "$HOME/.config/hypr/scripts/Decorations/shadow_toggle.sh"
        ;;
    "Rounding Toggle")
        bash "$HOME/.config/hypr/scripts/Decorations/rounding_toggle.sh"
        ;;
    *)
        exit 0
        ;;
esac
