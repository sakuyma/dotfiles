from pathlib import Path
from typing import List, Final

HOME: Final[Path] = Path.home()
DOTFILES_DIR: Final[Path] = Path.home() / ".dotfiles"
DOTFILES_CONFIG: Final[Path] = DOTFILES_DIR / "config"
CONFIG_DIR: Final[Path] = Path.home() / ".config"
CACHE_DIR: Final[Path] = Path.home() / ".cache" / "dotfiles"
LOG_DIR: Final[Path] = Path.home() / ".local" / "share" / "dotfiles" / "logs"

SYSTEM_PACKAGES: Final[List[str]] = ["git", "rustup", "python", "go", "npmcurl", "wget"]

AUR_PACKAGES: Final[List[str]] = [
    "paru",
    "bibata-cursor-theme-bin",
    "booster-um",
    "pyprland",
    "hyprrecord",
    "eww",
    "ttf-google-fonts-git",
    "tty-clock",
    "waybar-git",
    "wlogout",
    "zen-browser-bin",
]
ALL_PACKAGES: Final[List[str]] = [*SYSTEM_PACKAGES, *AUR_PACKAGES]

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
    RESET: str = ":\033[0m"
