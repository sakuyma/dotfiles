#!/usr/bin/env python3

import sys
import os
import subprocess
import getpass
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
        return os.environ.get("USER"), Path.home()

    # we are root, user is dumb
    user = os.environ.get("SUDO_USER")
    if user and user != "root":
        return user, Path(f"/home/{user}")

    # fallback for when USER is actually root
    return None, None


def ask_password() -> Optional[str]:
    """I declare under oath that I won't fuck this up (probably)"""
    try:
        print(
            f"{Colors.BLUE}╔════════════════════════════════════════════════════════════╗{Colors.RESET}"
        )
        print(
            f"{Colors.BLUE}║  🔐 SUDO NEEDED                                            ║{Colors.RESET}"
        )
        print(
            f"{Colors.BLUE}║                                                            ║{Colors.RESET}"
        )
        print(
            f"{Colors.BLUE}║  I promise this is not a virus (tm)                        ║{Colors.RESET}"
        )
        print(
            f"{Colors.BLUE}║  I just need to touch some system files                    ║{Colors.RESET}"
        )
        print(
            f"{Colors.BLUE}║  Your files are fine, probably                             ║{Colors.RESET}"
        )
        print(
            f"{Colors.BLUE}║                                                            ║{Colors.RESET}"
        )
        print(
            f"{Colors.BLUE}╚════════════════════════════════════════════════════════════╝{Colors.RESET}"
        )

        password = getpass.getpass(
            f"{Colors.YELLOW}🔒 Sudo password for {os.environ.get('USER')}: {Colors.RESET}"
        )
        return password
    except KeyboardInterrupt:
        print(f"\n{Colors.RED}✗ Nope, I'm out{Colors.RESET}")
        return None


def check_sudo_permission(password: str) -> bool:
    """Check if the password is correct"""
    result = subprocess.run(
        ["sudo", "-S", "echo", "ok"],
        input=password + "\n",
        capture_output=True,
        text=True,
    )
    return result.returncode == 0


def print_banner() -> None:
    """Show startup banner with info about current mode"""
    print("=" * 60)
    print(f"{Colors.GREEN}Sakuyma dotfiles installation script{Colors.RESET}")
    print("=" * 60)


def main() -> bool:
    global ORIGINAL_USER, ORIGINAL_HOME

    # if running as root, warn but continue
    if os.geteuid() == 0:
        print(
            f"{Colors.YELLOW}⚠ Running as root. This is not recommended.{Colors.RESET}"
        )
        response = input("Continue anyway? [y/N]: ").strip().lower()
        if response not in ["y", "yes"]:
            return False

    # figure out who we really are
    ORIGINAL_USER, ORIGINAL_HOME = get_original_user()

    # if we are root but cant find original user, freak the fuck out
    if os.geteuid() == 0 and ORIGINAL_USER is None:
        print(
            f"{Colors.RED}Cannot determine original user. Please run without sudo.{Colors.RESET}"
        )
        return False

    print_banner()

    # ask for sudo password if not already root
    if os.geteuid() != 0:
        password = ask_password()
        if password is None:
            return False

        if not check_sudo_permission(password):
            print(f"{Colors.RED}✗ Incorrect sudo password{Colors.RESET}")
            return False

        print(f"{Colors.GREEN}✓ Sudo access granted{Colors.RESET}\n")

        # store password for child modules
        os.environ["SUDO_PASSWORD"] = password

    # pass user info to child modules via environment
    if ORIGINAL_USER:
        os.environ["INSTALLER_ORIGINAL_USER"] = ORIGINAL_USER
        os.environ["INSTALLER_ORIGINAL_HOME"] = str(ORIGINAL_HOME)

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
            # clear sensitive data on failure
            os.environ.pop("SUDO_PASSWORD", None)
            return False

        print(f"{Colors.GREEN}✓ {name} complete{Colors.RESET}")

    print("\n" + "=" * 60)
    print(f"{Colors.GREEN}✓ Installation complete!{Colors.RESET}")
    print("=" * 60)

    # clear sensitive data
    os.environ.pop("SUDO_PASSWORD", None)

    return True


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
