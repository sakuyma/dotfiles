import subprocess
from pathlib import Path
from installer.env import DOTFILES_DIR, DOTFILES_CONFIG, DOTFILES_REPO, HOME, Colors


def _download_dotfiles() -> bool:
    """Clone or update dotfiles repo"""
    if DOTFILES_DIR.exists():
        print(f"Dotfiles already exist at {DOTFILES_DIR}")
        result = subprocess.run(
            ["git", "-C", str(DOTFILES_DIR), "pull"],
            capture_output=True,
            text=True,
        )
        if result.returncode == 0:
            return True
        else:
            print(f"Failed to update: {result.stderr}")
            return False

    result = subprocess.run(
        ["git", "clone", DOTFILES_REPO, str(DOTFILES_DIR)],
        capture_output=True,
        text=True,
    )

    if result.returncode == 0:
        return True
    else:
        print(f"Failed to clone: {result.stderr}")
        return False


def _symlink_dotfiles() -> bool:
    """Create symlinks using stow"""
    config_dir = Path(DOTFILES_CONFIG)
    if not config_dir.exists():
        print(
            f"{Colors.YELLOW}Config directory not found: {DOTFILES_CONFIG}{Colors.RESET}"
        )
        print(f"{Colors.YELLOW}Creating it...{Colors.RESET}")
        config_dir.mkdir(parents=True, exist_ok=True)
        print(
            f"{Colors.YELLOW}No configs to symlink yet. Add your dotfiles to {DOTFILES_CONFIG}{Colors.RESET}"
        )
        return True  # Not a failure, just nothing to symlink

    # check if there are any packages/directories to stow
    items = [item for item in config_dir.iterdir() if item.is_dir()]
    if not items:
        print(f"{Colors.YELLOW}No packages found in {DOTFILES_CONFIG}{Colors.RESET}")
        print(f"{Colors.YELLOW}Nothing to symlink{Colors.RESET}")
        return True

    # run stow on each directory
    success = True
    for item in items:
        package_name = item.name
        print(f"{Colors.BLUE}  Stowing: {package_name}{Colors.RESET}")
        try:
            result = subprocess.run(
                [
                    "stow",
                    "-d",
                    str(DOTFILES_CONFIG),
                    "-t",
                    str(HOME),
                    "--restow",
                    package_name,
                ],
                capture_output=True,
                text=True,
            )

            if result.returncode != 0:
                print(
                    f"{Colors.RED}    Failed to stow {package_name}: {result.stderr}{Colors.RESET}"
                )
                success = False
            else:
                print(f"{Colors.GREEN}    ✓ {package_name} stowed{Colors.RESET}")
        except FileNotFoundError:
            print(
                f"{Colors.RED}stow is not installed. Please install it: sudo pacman -S stow{Colors.RESET}"
            )
            return False

    return success


def setup_dotfiles() -> bool:
    """Main entry point - get and link dotfiles"""
    print("Setting up dotfiles...")

    if not _download_dotfiles():
        return False

    if not _symlink_dotfiles():
        return False

    print("Dotfiles setup complete")
    return True
