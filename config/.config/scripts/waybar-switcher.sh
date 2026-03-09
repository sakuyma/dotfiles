#!/bin/bash

# Используем абсолютные пути
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$HOME/.themes-waybar"
WAYBAR_DIR="$HOME/.config/waybar"
WAYBAR_LOG="/tmp/waybar.log"

show_notification() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -t 3000 "Waybar Theme Switcher" "$1"
    fi
    echo "$1"
}

restart_waybar() {
    echo "Restarting Waybar..."
    
    pkill -x "waybar" >/dev/null 2>&1
    sleep 0.5
    
    if pgrep -x "waybar" > /dev/null; then
        pkill -9 -x "waybar" >/dev/null 2>&1
        sleep 0.5
    fi
    
    waybar > "$WAYBAR_LOG" 2>&1 &
    local waybar_pid=$!
    
    sleep 0.5
    
    if ps -p $waybar_pid > /dev/null 2>&1; then
        echo "Waybar started (PID: $waybar_pid)"
        return 0
    else
        echo "Waybar failed to start"
        echo "Logs: $WAYBAR_LOG"
        show_notification "Failed to start Waybar"
        return 1
    fi
}

# Проверяем существование директорий
echo "Checking directories..."
echo "Themes dir: $THEMES_DIR"
echo "Waybar dir: $WAYBAR_DIR"

if [ ! -d "$THEMES_DIR" ]; then
    show_notification "Themes directory doesn't exist: $THEMES_DIR"
    exit 1
fi

if [ ! -d "$WAYBAR_DIR" ]; then
    show_notification "Waybar directory doesn't exist: $WAYBAR_DIR"
    exit 1
fi

# Собираем темы с подробным выводом
themes=()
echo "Searching for themes in: $THEMES_DIR"
for theme in "$THEMES_DIR"/*/; do
    if [ -d "$theme" ]; then
        theme_name=$(basename "$theme")
        themes+=("$theme_name")
        echo "Found theme: $theme_name"
    fi
done

if [ ${#themes[@]} -eq 0 ]; then
    show_notification "No themes found in directory: $THEMES_DIR"
    echo "Contents of themes directory:"
    ls -la "$THEMES_DIR"
    exit 1
fi

# Запускаем rofi
selected_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -p "Waybar Theme:" -theme "~/.config/rofi/launcher.rasi")

if [ -z "$selected_theme" ]; then
    echo "No theme selected"
    exit 0
fi

echo "Selected theme: $selected_theme"

theme_path="$THEMES_DIR/$selected_theme"

if [ ! -d "$theme_path" ]; then
    show_notification "Theme doesn't exist: $selected_theme"
    echo "Theme path not found: $theme_path"
    exit 1
fi

# Проверяем, есть ли файлы в теме
echo "Theme files:"
ls -la "$theme_path"

echo "Copying theme files to $WAYBAR_DIR..."
if cp -rv "$theme_path"/* "$WAYBAR_DIR/" 2>&1; then
    show_notification "Theme applied: $selected_theme"
    
    if ! restart_waybar; then
        show_notification "Failed to restart Waybar"
        exit 1
    fi
else
    show_notification "Error copying theme files"
    echo "Copy failed"
    exit 1
fi

echo "Done!"
