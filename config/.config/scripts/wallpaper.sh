#!/usr/bin/env bash

# ---------------- Configuration ----------------
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-thumbnails"
PERSISTENT_WALL="$HOME/.current_wallpaper"

# ---------------- Setup ----------------
mkdir -p "$CACHE_DIR"

# ---------------- Collect wallpapers ----------------
mapfile -t wallpapers < <(
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \)
)

# ---------------- Build rofi input ----------------
rofi_input=""
for wall in "${wallpapers[@]}"; do
    filename=$(basename "$wall")
    thumb="$CACHE_DIR/${filename%.*}.png"

    # Generate thumbnail if missing
    if [[ ! -f "$thumb" ]]; then
        magick "$wall" -thumbnail 480x270^ -gravity center -extent 480x270 "$thumb"
    fi

    rofi_input+="$filename\x00icon\x1f$thumb\n"
done

# ---------------- Rofi picker ----------------
selected_name=$(echo -e "$rofi_input" | rofi -dmenu -i -p "Wallpaper" \
    -show-icons \
    -theme ~/.config/rofi/wallpaper.rasi)

# ---------------- Apply wallpaper ----------------
if [[ -n "$selected_name" ]]; then
    FULL_PATH="$WALLPAPER_DIR/$selected_name"

    # Persistent symlink
    ln -sf "$FULL_PATH" "$PERSISTENT_WALL"

    # Apply wallpaper (Sway preferred)
    if pgrep -x awww-daemon> /dev/null; then
        awww img "$FULL_PATH" --transition-type any --transition-fps 180
    fi
fi

