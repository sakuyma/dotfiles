if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=Hyprland
    
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland
    
    export MOZ_ENABLE_WAYLAND=1
    
    exec Hyprland > ~/.hyprland.log 2>&1

    zsh -l
fi
