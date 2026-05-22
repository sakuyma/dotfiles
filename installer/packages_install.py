import subprocess
import os
from installer.env import ALL_PACKAGES, Colors


def install_packages() -> bool:
    print(f"{Colors.BLUE}Installing {len(ALL_PACKAGES)} packages...{Colors.RESET}")

    # get the original user (set by install.py when running with sudo)
    original_user = os.environ.get("INSTALLER_ORIGINAL_USER")

    # if we're root and have original user, run paru as that user
    if os.geteuid() == 0 and original_user:
        print(f"{Colors.BLUE}Running paru as user: {original_user}{Colors.RESET}")
        cmd = [
            "sudo",
            "-u",
            original_user,
            "paru",
            "-S",
            "--noconfirm",
            "--needed",
            *ALL_PACKAGES,
        ]
        result = subprocess.run(cmd, capture_output=True, text=True)
    else:
        # running as normal user (or no original user found)
        result = subprocess.run(
            ["paru", "-S", "--noconfirm", "--needed", *ALL_PACKAGES],
            capture_output=True,
            text=True,
        )

    if result.returncode == 0:
        print(f"{Colors.GREEN}All packages installed successfully{Colors.RESET}")
        return True
    else:
        print(f"{Colors.RED}Failed to install packages{Colors.RESET}")
        print(f"Error: {result.stderr}")
        return False
