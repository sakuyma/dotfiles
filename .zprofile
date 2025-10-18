# Автозапуск Hyprland только на tty1
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    # Wayland переменные
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=Hyprland
    
    # QT и GTK настройки
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland
    
    # Firefox Wayland
    export MOZ_ENABLE_WAYLAND=1
    
    # Запуск Hyprland
    exec Hyprland > ~/.hyprland.log 2>&1
fi
