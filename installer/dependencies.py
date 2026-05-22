import shutil
import subprocess
import os
from typing import List
from .env import Colors

dependencies: List[str] = ["git", "rustup", "python", "stow"]


def _run_with_sudo(cmd: List[str], capture: bool = False) -> tuple[int, str, str]:
    """Run command with sudo using stored password if available"""
    password = os.environ.get('SUDO_PASSWORD')
    
    if password:
        full_cmd = ["sudo", "-S"] + cmd
        result = subprocess.run(
            full_cmd,
            input=password + '\n',
            capture_output=True,
            text=True
        )
        return result.returncode, result.stdout, result.stderr
    else:
        # fallback to regular sudo (will prompt)
        full_cmd = ["sudo"] + cmd
        result = subprocess.run(full_cmd, capture_output=capture, text=True)
        return result.returncode, result.stdout if capture else "", result.stderr if capture else ""


def _install_aur_helper() -> bool:
    """Build and install paru from AUR (does NOT need sudo for build)"""
    print(f"{Colors.BLUE}Installing paru (AUR helper)...{Colors.RESET}")
    
    # clean up old clone
    subprocess.run(["rm", "-rf", "/tmp/paru"], capture_output=True)
    
    # clone paru (as normal user)
    clone = subprocess.run(
        ["git", "clone", "https://aur.archlinux.org/paru.git", "/tmp/paru"],
        capture_output=True, text=True
    )
    
    if clone.returncode != 0:
        print(f"{Colors.RED}Failed to clone paru: {clone.stderr}{Colors.RESET}")
        return False
    
    # build and install - makepkg should NOT run as root
    # but the final install part needs sudo, which paru handles
    build = subprocess.run(
        "cd /tmp/paru && makepkg -si --noconfirm",
        shell=True, capture_output=True, text=True
    )
    
    if build.returncode != 0:
        print(f"{Colors.RED}Failed to build paru: {build.stderr}{Colors.RESET}")
        return False
    
    print(f"{Colors.GREEN}✓ paru installed successfully{Colors.RESET}")
    return True


def _install_dependencies() -> bool:
    """Install dependencies via pacman (needs root)"""
    print(f"{Colors.BLUE}Installing dependencies with pacman...{Colors.RESET}")
    
    cmd = ["pacman", "-S", "--noconfirm", "--needed", *dependencies]
    returncode, stdout, stderr = _run_with_sudo(cmd, True)

    if returncode == 0:
        print(f"{Colors.GREEN}✓ Dependencies installed{Colors.RESET}")
        return True
    else:
        print(f"{Colors.RED}Failed to install dependencies: {stderr}{Colors.RESET}")
        return False


def configure_dependencies() -> bool:
    """Main entry point - sets up paru and basic packages"""
    print(f"{Colors.BLUE}Checking system dependencies...{Colors.RESET}")
    
    if shutil.which("pacman") is None:
        print(f"{Colors.RED}This script requires Arch Linux or an Arch-based distribution{Colors.RESET}")
        return False
    
    if shutil.which("paru") is None:
        print(f"{Colors.YELLOW}Paru not found, installing...{Colors.RESET}")
        if not _install_aur_helper():
            return False
    
    return _install_dependencies()
