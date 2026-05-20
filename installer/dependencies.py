import shutil
import subprocess
from typing import List

dependencies: List[str] = ["git", "rustup", "python", "stow"]


def _install_aur_helper() -> bool:
    print("Installing paru (AUR helper)...")
    
    clone = subprocess.run(
        ["git", "clone", "https://aur.archlinux.org/paru.git", "/tmp/paru"],
        capture_output=True,
        text=True
    )
    
    if clone.returncode != 0:
        print(f"Failed to clone paru: {clone.stderr}")
        return False
    
    build = subprocess.run(
        "cd /tmp/paru && makepkg -si --noconfirm",
        shell=True,
        capture_output=True,
        text=True
    )
    
    if build.returncode != 0:
        print(f"Failed to build paru: {build.stderr}")
        return False
    
    print("paru was installed successfully")
    return True


def _install_dependencies() -> bool:
    result = subprocess.run(
        ["pacman", "-S", "--noconfirm", *dependencies],
        capture_output=True,
        text=True,
    )

    if result.returncode == 0:
        print("Packages successfully installed")
        return True
    else:
        print(f"Error: {result.stderr}")
        return False


def configure_dependencies() -> bool:
    if shutil.which("pacman") is None:
        print("You need to be on Arch/Arch based system to use this script")
        return False
    
    if shutil.which("paru") is None:
        print("paru not found, installing...")
        if not _install_aur_helper():
            print("Failed to install AUR helper")
            return False
        print("paru installed, continuing...")
    
    return _install_dependencies()
