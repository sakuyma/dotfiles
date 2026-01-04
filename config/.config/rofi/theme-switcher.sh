#!/bin/bash

THEMES_DIR="$HOME/.themes"
CONFIG_DIR="$HOME/.config"

if [ ! -d "$THEMES_DIR" ]; then
    echo "❌ Themes directory not found: $THEMES_DIR"
    exit 1
fi

themes=($(find "$THEMES_DIR" -maxdepth 1 -type d -printf "%f\n" | tail -n +2))

if [ ${#themes[@]} -eq 0 ]; then
    echo "❌ No themes found in $THEMES_DIR"
    exit 1
fi

selected_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -p "🎨 Select theme:" -config ~/.config/rofi/theme-switcher.rasi)

if [ -z "$selected_theme" ]; then
    echo "ℹ️  No theme selected"
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
    local font_name="Noto Sans 10"
    local wallpaper=""
    local firefox_theme_id=""

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
                firefox_theme_id)
                    firefox_theme_id="$value"
                    ;;
            esac
        done < "$config_file"
    fi
    
    echo "$gtk_theme|$icon_theme|$cursor_theme|$font_name|$wallpaper|$firefox_theme_id"
}

remove_firefox_theme_prefs() {
    local prefs_file="$1"
    
    if [ ! -f "$prefs_file" ]; then
        return
    fi
    
    # Create temp file without theme prefs
    grep -v -E '(user_pref\("extensions\.activeThemeID"|user_pref\("lightweightThemes\.selectedThemeID"|user_pref\("browser\.theme\.")' "$prefs_file" > "${prefs_file}.tmp" 2>/dev/null
    
    if [ -f "${prefs_file}.tmp" ]; then
        mv "${prefs_file}.tmp" "$prefs_file"
    fi
}

apply_firefox_theme_by_id() {
    local prefs_file="$1"
    local theme_id="$2"
    
    # Remove existing theme preferences
    remove_firefox_theme_prefs "$prefs_file"
    
    # Add new theme preferences
    {
        echo "// Firefox Theme: $theme_id (applied by theme-switcher)"
        echo "user_pref(\"extensions.activeThemeID\", \"$theme_id\");"
        echo "user_pref(\"lightweightThemes.selectedThemeID\", \"$theme_id\");"
        echo "user_pref(\"browser.theme.toolbar-theme\", 0);"
        echo "user_pref(\"browser.theme.content-theme\", 0);"
        
        # Auto-detect dark/light based on theme ID
        if [[ "$theme_id" =~ [Dd]ark|[Bb]lack|[Nn]ight ]]; then
            echo "user_pref(\"ui.systemUsesDarkTheme\", 0);"
            echo "user_pref(\"layout.css.prefers-color-scheme.content-override\", 0);"
        elif [[ "$theme_id" =~ [Ll]ight|[Ww]hite ]]; then
            echo "user_pref(\"ui.systemUsesDarkTheme\", 1);"
            echo "user_pref(\"layout.css.prefers-color-scheme.content-override\", 1);"
        else
            echo "user_pref(\"ui.systemUsesDarkTheme\", 2);"
            echo "user_pref(\"layout.css.prefers-color-scheme.content-override\", 2);"
        fi
    } >> "$prefs_file"
}

apply_firefox_theme() {
    local firefox_theme_id="$1"
    
    if [ -z "$firefox_theme_id" ]; then
        echo "ℹ️  No Firefox theme ID specified"
        return
    fi
    
    # Detect Firefox profile directory
    local firefox_dir="$HOME/.mozilla/firefox"
    local profile_dir=""
    
    if [ -d "$firefox_dir" ]; then
        profile_dir=$(find "$firefox_dir" -maxdepth 1 -name "*.default-release" -type d | head -n 1)
        if [ -z "$profile_dir" ]; then
            profile_dir=$(find "$firefox_dir" -maxdepth 1 -name "*.default" -type d | head -n 1)
        fi
    fi
    
    if [ -z "$profile_dir" ] || [ ! -d "$profile_dir" ]; then
        echo "⚠️  Firefox profile not found"
        return
    fi
    
    local prefs_file="$profile_dir/prefs.js"
    
    echo "Applying Firefox theme ID: $firefox_theme_id"
    
    # Backup prefs.js
    if [ -f "$prefs_file" ]; then
        cp "$prefs_file" "$prefs_file.backup" 2>/dev/null
        echo "📁 Backup created: $prefs_file.backup"
    else
        touch "$prefs_file"
    fi
    
    # Apply theme via prefs.js
    apply_firefox_theme_by_id "$prefs_file" "$firefox_theme_id"
    
    echo "✅ Firefox theme applied: $firefox_theme_id"
}

apply_theme() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"
    
    if [ ! -d "$theme_path" ]; then
        echo "❌ Theme directory not found: $theme_path"
        return 1
    fi
    
    # Read theme configuration
    IFS='|' read -r gtk_theme icon_theme cursor_theme font_name wallpaper firefox_theme_id <<< "$(read_theme_config "$theme_path")"
    
    echo "Applying theme: $selected_theme"
    echo "  GTK: $gtk_theme"
    echo "  Icons: $icon_theme"
    echo "  Cursors: $cursor_theme"
    echo "  Font: $font_name"
    echo "  Firefox: $firefox_theme_id"
    
    # Copy each theme subdirectory to corresponding config folder
    if [ -d "$theme_path" ]; then
        for app_dir in "$theme_path"/*; do
            if [ -d "$app_dir" ] && [ "$(basename "$app_dir")" != "theme.conf" ]; then
                local app_name=$(basename "$app_dir")
                local target_dir="$CONFIG_DIR/$app_name"
                
                echo "📁 Copying $app_name config..."
                mkdir -p "$target_dir"
                cp -r "$app_dir"/* "$target_dir/" 2>/dev/null && echo "  ✅ $app_name config applied" || echo "  ⚠️  Could not copy $app_name config"
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
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null && echo "  ✅ GTK theme set"
        
        # Icon theme
        gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" 2>/dev/null && echo "  ✅ Icon theme set"
        
        # Cursor theme
        gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" 2>/dev/null && echo "  ✅ Cursor theme set"
        
        # Font
        gsettings set org.gnome.desktop.interface font-name "$font_name" 2>/dev/null && echo "  ✅ Font set"
    fi
    
    # Alternative method for non-GNOME environments
    if command -v xfconf-query >/dev/null 2>&1; then
        echo "⚙️  Applying XFCE settings..."
        xfconf-query -c xsettings -p /Net/ThemeName -s "$gtk_theme" 2>/dev/null && echo "  ✅ XFCE theme set"
        xfconf-query -c xsettings -p /Net/IconThemeName -s "$icon_theme" 2>/dev/null && echo "  ✅ XFCE icons set"
        xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "$cursor_theme" 2>/dev/null && echo "  ✅ XFCE cursors set"
    fi
    
    # Update icon cache
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        echo "🔍 Updating icon cache..."
        # Update cache for home directory
        if [ -d "$HOME/.icons/$icon_theme" ]; then
            gtk-update-icon-cache -f "$HOME/.icons/$icon_theme" 2>/dev/null && echo "  ✅ User icons cached"
        fi
        # Update cache for system icons
        if [ -d "/usr/share/icons/$icon_theme" ]; then
            sudo gtk-update-icon-cache -f "/usr/share/icons/$icon_theme" 2>/dev/null && echo "  ✅ System icons cached" || echo "  ⚠️  Could not cache system icons"
        fi
    fi
    
    # Apply Firefox theme
    apply_firefox_theme "$firefox_theme_id"
    
    # Wallpaper handling
    if [ -n "$wallpaper" ] && [ -f "$theme_path/$wallpaper" ]; then
        echo "🖼️  Setting wallpaper: $wallpaper"
        swww img "$theme_path/$wallpaper" --transition-type any --transition-fps 60 >/dev/null 2>&1 && echo "  ✅ Wallpaper set"
    elif [ -f "$theme_path/wallpaper.jpg" ]; then
        echo "🖼️  Setting wallpaper: wallpaper.jpg"
        swww img "$theme_path/wallpaper.jpg" --transition-type any --transition-fps 60 >/dev/null 2>&1 && echo "  ✅ Wallpaper set"
    elif [ -f "$theme_path/wallpaper.png" ]; then
        echo "🖼️  Setting wallpaper: wallpaper.png"
        swww img "$theme_path/wallpaper.png" --transition-type any --transition-fps 60 >/dev/null 2>&1 && echo "  ✅ Wallpaper set"
    else
        echo "⚠️  No wallpaper found"
    fi
    
    # Restart waybar
    if pgrep waybar > /dev/null; then
        echo "🔄 Restarting waybar..."
        pkill waybar >/dev/null 2>&1
        sleep 0.5
    fi
    waybar >/dev/null 2>&1 &
    echo "  ✅ Waybar restarted"
    
    # Restart dunst
    if pgrep dunst > /dev/null; then
        echo "🔄 Restarting dunst..."
        pkill dunst >/dev/null 2>&1
        sleep 0.5
    fi
    dunst >/dev/null 2>&1 &
    echo "  ✅ Dunst restarted"
    
    # Theme change notification
    if command -v notify-send >/dev/null 2>&1; then
        local notification="Theme '$selected_theme' applied\n• GTK: $gtk_theme\n• Icons: $icon_theme\n• Cursors: $cursor_theme\n• Font: $font_name"
        if [ -n "$firefox_theme_id" ]; then
            notification="$notification\n• Firefox: $firefox_theme_id"
        fi
        notify-send "Theme Changed" "$notification"
    fi
    
    echo "🎉 Theme successfully applied: $selected_theme"
}

# Main execution
echo "🚀 Starting theme switcher..."
apply_theme "$selected_theme"
