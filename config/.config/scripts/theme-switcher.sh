#!/bin/bash

THEMES_DIR="$HOME/.themes"
CONFIG_DIR="$HOME/.config"

if [ ! -d "$THEMES_DIR" ]; then
    echo "Themes directory not found: $THEMES_DIR"
    exit 1
fi

themes=($(find "$THEMES_DIR" -maxdepth 1 -type d -printf "%f\n" | tail -n +2))

if [ ${#themes[@]} -eq 0 ]; then
    echo "No themes found in $THEMES_DIR"
    exit 1
fi

selected_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -p "Select theme:" -theme ~/.config/rofi/launcher.rasi)

if [ -z "$selected_theme" ]; then
    echo "  No theme selected"
    exit 0
fi

# Function to read theme config
read_theme_config() {
    local theme_path="$1"
    local config_file="$theme_path/theme.conf"
    
    # Default values
    local gtk_theme="$selected_theme"
    local icon_theme="$selected_theme"
    local cursor_theme="$selected_theme"
    local font_name="Google Sans Flex Medium 11.5"
    local wallpaper=""
    
    if [ -f "$config_file" ]; then
        while IFS='=' read -r key value; do
            # Remove quotes and spaces
            key=$(echo "$key" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
            value=$(echo "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/^"\(.*\)"$/\1/; s/^'"'"'\(.*\)'"'"'$/\1/')
            
            case "$key" in
                gtk_theme)
                    gtk_theme="$value"
                    ;;
                icon_theme)
                    icon_theme="$value"
                    ;;
                cursor_theme)
                    cursor_theme="$value"
                    ;;
                font_name)
                    font_name="$value"
                    ;;
                wallpaper)
                    wallpaper="$value"
                    ;;
            esac
        done < "$config_file"
    fi
    
    echo "$gtk_theme|$icon_theme|$cursor_theme|$font_name|$wallpaper"
}

apply_theme() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"
    
    if [ ! -d "$theme_path" ]; then
        echo "Theme directory not found: $theme_path"
        return 1
    fi
    
    # Read theme configuration
    IFS='|' read -r gtk_theme icon_theme cursor_theme font_name wallpaper firefox_theme_id <<< "$(read_theme_config "$theme_path")"
    
    echo "Applying theme: $selected_theme"
    echo "  GTK: $gtk_theme"
    echo "  Icons: $icon_theme"
    echo "  Cursors: $cursor_theme"
    echo "  Font: $font_name"
    
    # Copy each theme subdirectory to corresponding config folder
    if [ -d "$theme_path" ]; then
        for app_dir in "$theme_path"/*; do
            if [ -d "$app_dir" ] && [ "$(basename "$app_dir")" != "theme.conf" ]; then
                local app_name=$(basename "$app_dir")
                local target_dir="$CONFIG_DIR/$app_name"
                
                echo "Copying $app_name config..."
                mkdir -p "$target_dir"
                cp -r "$app_dir"/* "$target_dir/" 2>/dev/null && echo "  ✅ $app_name config applied" || echo "Could not copy $app_name config"
            fi
        done
    fi
    
    # Update GTK settings
    if command -v nwg-look >/dev/null 2>&1; then
        echo "🎨 Applying GTK settings with nwg-look..."
        nwg-look -a
    fi
    
    # Apply themes via gsettings
    if command -v gsettings >/dev/null 2>&1; then
        echo "⚙️  Applying GNOME settings..."
        # GTK theme
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null && echo "GTK theme set"
        
        # Icon theme
        gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" 2>/dev/null && echo "Icon theme set"
        
        # Cursor theme
        gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" 2>/dev/null && echo "Cursor theme set"
        
        # Font
        gsettings set org.gnome.desktop.interface font-name "$font_name" 2>/dev/null && echo "  ✅ Font set"
    fi
    
    # Update icon cache
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        echo "🔍 Updating icon cache..."
        # Update cache for home directory
        if [ -d "$HOME/.icons/$icon_theme" ]; then
            gtk-update-icon-cache -f "$HOME/.icons/$icon_theme" 2>/dev/null && echo "User icons cached"
        fi
        # Update cache for system icons
        if [ -d "/usr/share/icons/$icon_theme" ]; then
            sudo gtk-update-icon-cache -f "/usr/share/icons/$icon_theme" 2>/dev/null && echo "System icons cached" || echo "Could not cache system icons"
        fi
    fi
    
    # Wallpaper handling
    if [ -n "$wallpaper" ] && [ -f "$theme_path/$wallpaper" ]; then
        echo "🖼️  Setting wallpaper: $wallpaper"
        swww img "$theme_path/$wallpaper" --transition-type any --transition-fps 60 >/dev/null 2>&1 && echo "  ✅ Wallpaper set"
    elif [ -f "$theme_path/wallpaper.jpg" ]; then
        echo "Setting wallpaper: wallpaper.jpg"
        swww img "$theme_path/wallpaper.jpg" --transition-type any --transition-fps 60 >/dev/null 2>&1 && echo "  ✅ Wallpaper set"
    elif [ -f "$theme_path/wallpaper.png" ]; then
        echo "🖼️  Setting wallpaper: wallpaper.png"
        swww img "$theme_path/wallpaper.png" --transition-type any --transition-fps 60 >/dev/null 2>&1 && echo "  ✅ Wallpaper set"
    else
        echo "No wallpaper found"
    fi
    
    # Restart waybar
    # if pgrep waybar > /dev/null; then
    #    echo "🔄 Restarting waybar..."
    #    pkill waybar >/dev/null 2>&1
    #    sleep 0.5
    # fi
    # waybar >/dev/null 2>&1 &
    # echo "Waybar restarted"
    
    #Apply theme to kitty
    if pgrep kitty > /dev/null; then
        kill -SIGUSR1 $(pgrep kitty)
    fi

    #Apply tmux theme
    if pgrep tmux > /dev/null; then
        tmux source-file ~/.config/tmux/tmux.conf
    fi

    # apply nvim theme
    if pgrep nvim > /dev/null; then 
        kill -SIGUSR1 $(pgrep nvim)
    fi

    # Restart swaync 
    if pgrep swaync > /dev/null; then
        pkill swaync >/dev/null 2>&1
    fi
    swaync >/dev/null 2>&1 &
   

    # Theme change notification
    if command -v notify-send >/dev/null 2>&1; then
        local notification="Theme '$selected_theme' applied\n• GTK: $gtk_theme\n• Icons: $icon_theme\n• Cursors: $cursor_theme\n• Font: $font_name"
        if [ -n "$firefox_theme_id" ]; then
            notification="$notification\n"
        fi
        notify-send "Theme Changed" "$notification"
    fi
    
    echo "Theme successfully applied: $selected_theme"
}

# Main execution
echo "Starting theme switcher..."
apply_theme "$selected_theme"
