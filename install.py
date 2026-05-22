#!/usr/bin/env python3

import sys
import os
import subprocess
from pathlib import Path
from typing import Optional

# add current dir to path so we can import installer module
sys.path.insert(0, str(Path(__file__).parent))

from installer import (
    configure_dependencies,
    install_packages,
    setup_dotfiles,
    setup_etc_configs,
    configure_services,
    Colors,
)

# NOTE: Important for sudo control
ORIGINAL_USER: Optional[str] = None
ORIGINAL_HOME: Optional[Path] = None


def get_original_user() -> tuple[Optional[str], Optional[Path]]:
    """Figure out who the real user is when script is run with sudo"""
    
    # not root? user is smart 
    if os.geteuid() != 0:
        return os.environ.get('USER'), Path.home()
    
    # we are root, user is dumb 
    user = os.environ.get('SUDO_USER')
    if user and user != 'root':
        return user, Path(f"/home/{user}")

    # fallback for when USER is actually root
    return None, None


def print_banner() -> None:
    """Show startup banner with info about current mode"""
    print("=" * 60)
    print(f"{Colors.GREEN}Sakuyma dotfiles installation script{Colors.RESET}")
    print("=" * 60)


def main() -> bool:
    global ORIGINAL_USER, ORIGINAL_HOME
    
    # figure out who we really are
    ORIGINAL_USER, ORIGINAL_HOME = get_original_user()
    
    # if we are root but cant find original user, freak the fuck out 
    if os.geteuid() == 0 and ORIGINAL_USER is None:
        print(f"{Colors.RED}Cannot determine original user. Please run without sudo.{Colors.RESET}")
        return False
    
    print_banner()
    
    # pass user info to child modules via environment
    if ORIGINAL_USER:
        os.environ['INSTALLER_ORIGINAL_USER'] = ORIGINAL_USER
        os.environ['INSTALLER_ORIGINAL_HOME'] = str(ORIGINAL_HOME)
    
    # define installation steps in order
    steps = [
        ("Dependencies", configure_dependencies),
        ("Packages", install_packages),
        ("Dotfiles", setup_dotfiles),
        ("ETC configs", setup_etc_configs),
        ("System services", configure_services),
    ]
    
    # NOTE: we run each step one by one and stop if anything fails
    for i, (name, func) in enumerate(steps, 1):
        print(f"\n[{i}/{len(steps)}] {name}...")
        
        if not func():
            print(f"{Colors.RED}✗ Failed at: {name}{Colors.RESET}")
            return False
        
        print(f"{Colors.GREEN}✓ {name} complete{Colors.RESET}")
    
    print("\n" + "=" * 60)
    print(f"{Colors.GREEN}✓ Installation complete!{Colors.RESET}")
    print("=" * 60)
    
    return True


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
