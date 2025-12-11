#!/bin/bash
# grub-setup.sh - With verification and diff output

set -e

[ "$EUID" -ne 0 ] && { echo "sudo required"; exit 1; }

GRUB_DEFAULT="/etc/default/grub"
GRUB_CFG="/boot/grub/grub.cfg"
NEW_PARAMS="loglevel=0 quiet rd.udev.log_priority=0 vt.global_cursor_default=0 systemd.show_status=auto splash mitigations=off nvidia-drm.modeset=1"

echo "=== Setting kernel parameters ==="
echo ""

# Show current parameters
echo "Current parameters:"
CURRENT_PARAMS=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "$GRUB_DEFAULT" 2>/dev/null || echo "Not found")
echo "$CURRENT_PARAMS"
echo ""

echo "New parameters:"
echo "GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_PARAMS\""
echo ""

# Request confirmation (can be commented for automatic execution)
read -p "Continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Set parameters
sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_PARAMS\"|" "$GRUB_DEFAULT"

# Generate config
grub-mkconfig -o "$GRUB_CFG" >/dev/null 2>&1 && echo "✓ Configuration updated" || echo "✗ Generation error"

echo ""
echo "Done!"
