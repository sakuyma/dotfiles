#!/bin/bash

LOCK_FILE="/tmp/titlebars.lock"

if [ -f "$LOCK_FILE" ]; then
    hyprctl plugin unload /var/cache/hyprpm/user/hyprland-plugins/hyprbars.so  
    rm -f "$LOCK_FILE"
else
    hyprctl plugin load /var/cache/hyprpm/user/hyprland-plugins/hyprbars.so 
    touch "$LOCK_FILE"
fi
