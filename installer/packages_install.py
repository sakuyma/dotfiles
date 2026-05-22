import subprocess
import os
from installer.env import ALL_PACKAGES, Colors


def install_packages() -> bool:
    """Install all packages - paru will use sudo from our stored password"""
    print(f"{Colors.BLUE}Installing {len(ALL_PACKAGES)} packages...{Colors.RESET}")
    
    result = subprocess.run(
        ["paru", "-S", "--noconfirm", "--needed", *ALL_PACKAGES],
        capture_output=True,
        text=True
    )

    if result.returncode == 0:
        print(f"{Colors.GREEN}All packages installed successfully{Colors.RESET}")
        return True
    else:
        print(f"{Colors.RED}Failed to install packages{Colors.RESET}")
        if result.stderr:
            print(f"Error: {result.stderr}")
        return False
