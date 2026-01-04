#!/bin/bash

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
    echo "🔄 Restarting Waybar..."
    
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
        echo "✅ Waybar started (PID: $waybar_pid)"
        return 0
    else
        echo "❌ Waybar failed to start"
        echo "Logs: $WAYBAR_LOG"
        show_notification "❌ Failed to start Waybar"
        return 1
    fi
}

if [ ! -d "$THEMES_DIR" ]; then
    show_notification "❌ Themes directory doesn't exist: $THEMES_DIR"
    exit 1
fi

if [ ! -d "$WAYBAR_DIR" ]; then
    show_notification "❌ Waybar directory doesn't exist: $WAYBAR_DIR"
    exit 1
fi

themes=()
while IFS= read -r -d $'\0' theme; do
    themes+=("$(basename "$theme")")
done < <(find "$THEMES_DIR" -maxdepth 1 -type d -not -path "$THEMES_DIR" -print0)

if [ ${#themes[@]} -eq 0 ]; then
    show_notification "❌ No themes found in directory: $THEMES_DIR"
    exit 1
fi

selected_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -p "🎨 Waybar Theme:" -theme "~/.config/rofi/waybar-switcher.rasi")

if [ -z "$selected_theme" ]; then
    exit 0
fi

theme_path="$THEMES_DIR/$selected_theme"

if [ ! -d "$theme_path" ]; then
    show_notification "❌ Theme doesn't exist: $selected_theme"
    exit 1
fi

echo "📁 Copying theme files..."
if cp -r "$theme_path"/* "$WAYBAR_DIR/" 2>/dev/null; then
    show_notification "✅ Theme applied: $selected_theme"
    
    if ! restart_waybar; then
        show_notification "❌ Failed to restart Waybar"
        exit 1
    fi
else
    show_notification "❌ Error copying theme files"
    exit 1
fi
