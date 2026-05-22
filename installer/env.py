from pathlib import Path
from typing import List, Final

HOME: Final[Path] = Path.home()
DOTFILES_DIR: Final[Path] = Path.home() / ".dotfiles"
DOTFILES_CONFIG: Final[Path] = DOTFILES_DIR / "config"
DOTFILES_ETC: Final[Path] = DOTFILES_DIR / "etc"
CONFIG_DIR: Final[Path] = Path.home() / ".config"
CACHE_DIR: Final[Path] = Path.home() / ".cache" / "dotfiles"
LOG_DIR: Final[Path] = Path.home() / ".local" / "share" / "dotfiles" / "logs"

SYSTEM_PACKAGES: Final[List[str]] = [
    "git",
    "rustup",
    "python",
    "go",
    "npm",
    "curl",
    "wget",
    "booster",
    "booster-um",
]

USER_PACKAGES: Final[List[str]] = [
    # Audio things
    "pipewire",
    "pipewire-alsa",
    "pipewire-audio",
    "pipewire-jack",
    "gst-plugin-pipewire",
    "wireplumber",
    # gui for audio
    "pavucontrol",
    # bluetooth things
    "bluez",
    "bluez-utils",
    "blueman",
    # Other system things like brightness, etc
    "brightnessctl",
    "playerctl",
    "pamixer",
    "udiskie",
    # Network Things
    "network-manager",
    "iwd",
    "network-manager-applet",
]

DE_PACKAGES: Final[List[str]] = [
    "ly",
    "hyprland",
    "fuzzel",
    "waybar",
    "awww",
    "eww",
    "wlogout",
    "grim",
    "slurp",
    "cliphist",
    # hypr * things
    "hyprlock",
    "hyprsunset",
    "hypridle",
    "xdg-desktop-portal-hyprland",
    "polkit-gnome",
]

TERMINAL_PACKAGES: Final[List[str]] = [
    "zsh",
    "nvim",
    "eza",
    "ripgrep",
    "tty-clock",
    "fzf",
    "tmux",
    "loginctl",
    "sudo-rs",
    "yazi",
    "fastfetch",
    "pfetch",
    "nitch",
]


AUR_PACKAGES: Final[List[str]] = [
    "paru",
    "bibata-cursor-theme-bin",
    "pyprland",
    "hyprrecord",
    "ttf-google-fonts-git",
    "zen-browser-bin",
]
ALL_PACKAGES: Final[List[str]] = [
    *SYSTEM_PACKAGES,
    *AUR_PACKAGES,
    *SYSTEM_PACKAGES,
    *DE_PACKAGES,
    *TERMINAL_PACKAGES,
    *USER_PACKAGES,
]

ENABLED_SERVICES: Final[List[str]] = [
    "sshd",
    "NetworkManager",
    "docker",
    "chronyd",
    "iwd",
    "udisk2",
    "bluetooth",
]

DISABLED_SERVICES: Final[List[str]] = [
    "systemd-userdb",
    "NetworkManager-wait-online",
    "systemd-timesynced",
    "systemd-networkd",
]

DOTFILES_REPO: Final[str] = "https://github.com/sakuyma/dotfiles.git"


class Colors:
    RED: str = "\033[91m"
    GREEN: str = "\033[92m"
    YELLOW: str = "\033[93m"
    BLUE: str = "\033[94m"
    RESET: str = "\033[0m"
