#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

mkdir -p "$SCREENSHOT_DIR"

FILENAME="$SCREENSHOT_DIR/$(date '+%Y%m%d-%H:%M:%S').png"

TMP_FILE="/tmp/screenshot-$(date '+%s').png"

grim -g "$(slurp -o -r -c '##000000')" "$TMP_FILE"

if [ -f "$TMP_FILE" ]; then
    cp "$TMP_FILE" "$FILENAME"
    
    wl-copy --type image/png < "$TMP_FILE"
    
    notify-send "Screenshot saved" \
                "Saved to: $(basename "$FILENAME")\nCopied to clipboard" \
                --icon=gnome-screenshot \
                --expire-time=3000
    
    rm "$TMP_FILE"
    
    echo "Screenshot saved: $FILENAME"
else
    notify-send "Screenshot cancelled" \
                "No area selected" \
                --icon=dialog-error \
                --expire-time=2000
    echo "Screenshot cancelled"
    exit 1
fi
