#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='config-clipboard'

## Run
cliphist list | rofi -dmenu -p " Clipboard history: " -display-columns 2 -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy
