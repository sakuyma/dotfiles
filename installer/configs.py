import subprocess
from pathlib import Path
from env import DOTFILES_DIR, DOTFILES_CONFIG, DOTFILES_REPO, HOME

def _download_dotfiles() -> bool:
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
    config_dir = Path(DOTFILES_CONFIG)
    if not config_dir.exists():
        print(f"Config directory not found: {DOTFILES_CONFIG}")
        return False
    
    try:
        result = subprocess.run(
            ["stow", "-d", str(DOTFILES_CONFIG), "-t", str(HOME), "--restow"],
            capture_output=True,
            text=True,
        )
        
        if result.returncode == 0:
            return True
        else:
            print(f"Failed to create symlinks: {result.stderr}")
            return False
    except FileNotFoundError:
        print("stow is not installed. Please install it: sudo pacman -S stow")
        return False

def setup_dotfiles() -> bool:
    print("Setting up dotfiles...")
    
    if not _download_dotfiles():
        return False
    
    if not _symlink_dotfiles():
        return False
    
    print("Dotfiles setup complete")
    return True
