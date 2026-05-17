#!/usr/bin/env python3
"""
install.py - Main installation script with classes
"""
import os
import sys
import subprocess
import time
import shutil
import re
from pathlib import Path
from typing import Optional, List, Tuple
from dataclasses import dataclass


# ============================================================================
# COLOR CLASS
# ============================================================================
class Colors:
    """ANSI color codes for terminal output"""
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    CYAN = '\033[0;36m'
    MAGENTA = '\033[0;35m'
    NC = '\033[0m'  # No Color


# ============================================================================
# PRINTER CLASS
# ============================================================================
class Printer:
    """Handles all colored output"""
    
    @staticmethod
    def info(msg: str) -> None:
        print(f"{Colors.BLUE}[INFO]{Colors.NC} {msg}")
    
    @staticmethod
    def success(msg: str) -> None:
        print(f"{Colors.GREEN}[SUCCESS]{Colors.NC} {msg}")
    
    @staticmethod
    def warning(msg: str) -> None:
        print(f"{Colors.YELLOW}[WARNING]{Colors.NC} {msg}")
    
    @staticmethod
    def error(msg: str) -> None:
        print(f"{Colors.RED}[ERROR]{Colors.NC} {msg}")
    
    @staticmethod
    def step(msg: str) -> None:
        print(f"{Colors.CYAN}[STEP]{Colors.NC} {msg}")
    
    @staticmethod
    def header(msg: str) -> None:
        print(f"{Colors.MAGENTA}{msg}{Colors.NC}")
    
    @staticmethod
    def header_box(text: str, width: int = 70) -> None:
        """Print header with box"""
        print(f"{Colors.MAGENTA}╔{'═' * width}╗{Colors.NC}")
        print(f"{Colors.MAGENTA}║{text.center(width)}║{Colors.NC}")
        print(f"{Colors.MAGENTA}╚{'═' * width}╝{Colors.NC}")
    
    @staticmethod
    def spinner(pid: int, message: str) -> None:
        """Show animated spinner while process runs"""
        dots = ["", ".", "..", "..."]
        i = 0
        while True:
            try:
                os.kill(pid, 0)
            except OSError:
                break
            print(f"\r\033[K{Colors.BLUE}[INFO]{Colors.NC} {message}{dots[i % len(dots)]}", end="")
            sys.stdout.flush()
            time.sleep(0.4)
            i += 1
        print(f"\r\033[K", end="")


# ============================================================================
# SYSTEM CLASS
# ============================================================================
class System:
    """System information and utilities"""
    
    def __init__(self):
        self.script_path = Path(__file__).resolve()
        self.launched_by = str(self.script_path)
        self.script_dir = self.script_path.parent
        self.current_user = self._get_current_user()
        self.user_home = self._get_user_home()
    
    def _get_current_user(self) -> str:
        """Get current username (handles sudo)"""
        sudo_user = os.environ.get('SUDO_USER', '')
        user = os.environ.get('USER', '')
        
        if sudo_user and sudo_user != 'root':
            return sudo_user
        elif user and user != 'root':
            return user
        return sudo_user or "root"
    
    def _get_user_home(self) -> Path:
        """Get user home directory"""
        if self.current_user == "root" or not self.current_user:
            return Path("/root")
        return Path(f"/home/{self.current_user}")
    
    def check_sudo(self) -> None:
        """Check and request sudo privileges"""
        Printer.step("Step 1: Checking sudo privileges")
        
        if os.geteuid() != 0:
            Printer.warning("This script requires superuser privileges")
            Printer.info("Attempting to escalate privileges...")
            
            try:
                subprocess.run(["sudo", "-v"], check=True)
                Printer.info("Re-executing with sudo...")
                os.execvp("sudo", ["sudo", sys.executable] + sys.argv)
            except (subprocess.CalledProcessError, OSError):
                Printer.error("Failed to obtain sudo privileges")
                Printer.info(f"Please run this script with sudo: sudo {sys.argv[0]}")
                sys.exit(1)
        
        Printer.success("Running with superuser privileges")
        print()
    
    def check_nvidia_gpu(self) -> bool:
        """Check if NVIDIA GPU is present"""
        Printer.info("Checking for NVIDIA GPU...")
        
        try:
            result = subprocess.run(["lspci"], capture_output=True, text=True)
            if "nvidia" in result.stdout.lower():
                Printer.success("NVIDIA GPU detected")
                return True
        except FileNotFoundError:
            Printer.warning("lspci not found, cannot check for NVIDIA GPU")
        
        Printer.info("No NVIDIA GPU detected")
        return False
    
    def command_exists(self, cmd: str) -> bool:
        """Check if command exists"""
        return shutil.which(cmd) is not None
    
    def run_as_user(self, cmd: List[str]) -> subprocess.CompletedProcess:
        """Run command as original user (not root)"""
        if self.current_user != "root":
            return subprocess.run(["sudo", "-u", self.current_user] + cmd)
        return subprocess.run(cmd)


# ============================================================================
# AUR HELPER CLASS
# ============================================================================
class AURHelper:
    """Handles paru installation"""
    
    def __init__(self, system: System):
        self.system = system
    
    def install(self) -> bool:
        """Install paru AUR helper"""
        if self.system.command_exists("paru"):
            Printer.success("AUR helper already installed")
            return True
        
        Printer.info("paru not found. Installing AUR helper...")
        
        # Try to install from community repo first
        check = subprocess.run(["pacman", "-Si", "paru"], capture_output=True)
        if check.returncode == 0:
            Printer.info("Installing paru from official repositories...")
            process = subprocess.Popen(
                ["pacman", "-S", "--noconfirm", "paru"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            Printer.spinner(process.pid, "Installing paru")
            process.wait()
        
        # If still not installed, build from AUR
        if not self.system.command_exists("paru"):
            return self._build_from_aur()
        
        Printer.success("AUR helper installed successfully")
        return True
    
    def _build_from_aur(self) -> bool:
        """Build paru from AUR"""
        Printer.info("Installing build dependencies...")
        result = subprocess.run(
            ["pacman", "-S", "--needed", "--noconfirm", "base-devel", "git"],
            capture_output=True
        )
        if result.returncode != 0:
            Printer.error("Failed to install build dependencies")
            return False
        
        Printer.info("Cloning paru from AUR...")
        paru_dir = Path("/tmp/paru")
        if paru_dir.exists():
            shutil.rmtree(paru_dir)
        
        result = subprocess.run(
            ["git", "clone", "https://aur.archlinux.org/paru.git", str(paru_dir)],
            capture_output=True
        )
        if result.returncode != 0:
            Printer.error("Failed to clone paru repository")
            return False
        
        Printer.info("Building and installing paru...")
        os.chdir(paru_dir)
        
        if self.system.current_user == "root":
            Printer.error("Cannot build AUR package as root")
            return False
        
        # Run makepkg as normal user
        result = self.system.run_as_user(["makepkg", "-si", "--noconfirm"])
        
        os.chdir("/tmp")
        shutil.rmtree(paru_dir)
        
        return result.returncode == 0


# ============================================================================
# NVIDIA DRIVER CLASS
# ============================================================================
class NvidiaDriver:
    """Handles NVIDIA driver installation and configuration"""
    
    def __init__(self, system: System):
        self.system = system
        self.kernel_cmdline = Path("/etc/kernel/cmdline")
    
    def install(self) -> bool:
        """Install and configure NVIDIA drivers"""
        Printer.header("=== NVIDIA Driver Installation and Configuration ===")
        
        if not self.system.check_nvidia_gpu():
            Printer.error("NVIDIA graphics card not detected!")
            return False
        
        self._install_packages()
        self._configure_mkinitcpio()
        self._add_kernel_parameters()
        self._check_optimus()
        self._create_modprobe_config()
        
        Printer.success("=== NVIDIA driver installation completed ===")
        print()
        Printer.info("REBOOT REQUIRED to apply changes")
        print()
        Printer.info("After reboot, verify installation:")
        Printer.info("1. nvidia-smi - graphics card status")
        Printer.info("2. glxinfo | grep OpenGL - OpenGL information")
        Printer.info("3. nvidia-settings - NVIDIA settings")
        
        return True
    
    def _install_packages(self) -> None:
        """Install NVIDIA packages"""
        Printer.info("Installing NVIDIA packages...")
        
        base_packages = ["nvidia", "nvidia-utils", "nvidia-settings", "nvidia-prime"]
        vaapi_packages = ["libva-utils", "libva-mesa-driver"]
        
        # Check if already installed
        check = subprocess.run(["pacman", "-Qs", "nvidia"], capture_output=True)
        if check.returncode == 0:
            Printer.info("NVIDIA drivers already installed. Updating...")
            subprocess.run(["pacman", "-Syu", "--noconfirm", "--needed"] + base_packages, check=False)
        else:
            Printer.info("Installing NVIDIA drivers...")
            subprocess.run(["pacman", "-S", "--noconfirm", "--needed"] + base_packages, check=False)
        
        # Install VA-API packages
        Printer.info("Installing hardware video acceleration packages...")
        subprocess.run(["pacman", "-S", "--noconfirm", "--needed"] + vaapi_packages, check=False)
        
        # Check architecture for 32-bit libraries
        if os.uname().machine.endswith("64"):
            Printer.info("Installing 32-bit libraries...")
            subprocess.run(["pacman", "-S", "--noconfirm", "--needed", "lib32-nvidia-utils"], check=False)
        
        # Optional CUDA
        response = input("Install CUDA toolkit for GPU computing? (y/N): ")
        if response.lower() == 'y':
            Printer.info("Installing CUDA toolkit...")
            subprocess.run(["pacman", "-S", "--noconfirm", "--needed", "cuda"], check=False)
    
    def _configure_mkinitcpio(self) -> None:
        """Add NVIDIA modules to mkinitcpio.conf"""
        mkinitcpio_conf = Path("/etc/mkinitcpio.conf")
        backup = mkinitcpio_conf.with_suffix(f".conf.bak.{time.strftime('%Y%m%d_%H%M%S')}")
        
        Printer.info("Configuring mkinitcpio for NVIDIA modules...")
        
        # Create backup
        shutil.copy2(mkinitcpio_conf, backup)
        Printer.info(f"Backup created: {backup}")
        
        nvidia_modules = ["nvidia", "nvidia_modeset", "nvidia_uvm", "nvidia_drm"]
        
        with open(mkinitcpio_conf, 'r') as f:
            content = f.read()
        
        # Check if modules already present
        if 'nvidia' in content:
            missing = [m for m in nvidia_modules if m not in content]
            if missing:
                Printer.info(f"Adding missing modules: {missing}")
                pattern = r'^(MODULES=\(.*?)\)'
                replacement = r'\1 ' + ' '.join(missing) + ')'
                content = re.sub(pattern, replacement, content, flags=re.MULTILINE)
        else:
            if re.search(r'^MODULES=', content, re.MULTILINE):
                content = re.sub(
                    r'^(MODULES=\(.*?)\)',
                    r'\1 ' + ' '.join(nvidia_modules) + ')',
                    content,
                    flags=re.MULTILINE
                )
            else:
                content = re.sub(
                    r'^(#MODULES=.*)$',
                    rf'MODULES=({" ".join(nvidia_modules)})\n\1',
                    content,
                    flags=re.MULTILINE
                )
        
        # Disable nouveau if present
        if 'nouveau' in content:
            Printer.warning("Nouveau module detected. Recommended to disable it for NVIDIA.")
            response = input("Disable nouveau module? (y/N): ")
            if response.lower() == 'y':
                content = re.sub(r'\bnouveau\s*', '', content)
                content = re.sub(r'\(\s+', '(', content)
                content = re.sub(r'\s+\)', ')', content)
                Printer.success("Nouveau module disabled")
        
        with open(mkinitcpio_conf, 'w') as f:
            f.write(content)
        
        self._regenerate_initramfs()
    
    def _add_kernel_parameters(self) -> None:
        """Add NVIDIA kernel parameters to /etc/kernel/cmdline"""
        Printer.info("Adding kernel parameters for NVIDIA...")
        
        # Create directory if it doesn't exist
        self.kernel_cmdline.parent.mkdir(parents=True, exist_ok=True)
        
        # Read existing parameters
        existing_params = ""
        if self.kernel_cmdline.exists():
            existing_params = self.kernel_cmdline.read_text().strip()
        
        # Check if parameters already added
        if "nvidia-drm.modeset=1" not in existing_params:
            # Create backup
            if self.kernel_cmdline.exists():
                backup = self.kernel_cmdline.with_suffix(f".cmdline.bak.{time.strftime('%Y%m%d_%H%M%S')}")
                shutil.copy2(self.kernel_cmdline, backup)
                Printer.info(f"Backup created: {backup}")
            
            new_params = f"{existing_params} nvidia-drm.modeset=1".strip()
            self.kernel_cmdline.write_text(new_params)
            Printer.success("Kernel parameters added to /etc/kernel/cmdline")
            
            # Regenerate initramfs after kernel params change
            self._regenerate_initramfs()
        else:
            Printer.info("Kernel parameters for NVIDIA already configured")
    
    def _regenerate_initramfs(self) -> None:
        """Regenerate initramfs"""
        Printer.info("Regenerating initramfs...")
        
        # Find kernel preset
        presets_dir = Path("/etc/mkinitcpio.d")
        if presets_dir.exists():
            for preset in presets_dir.glob("*.preset"):
                kernel_name = preset.stem
                Printer.info(f"Regenerating for kernel: {kernel_name}")
                result = subprocess.run(["mkinitcpio", "-p", kernel_name])
                if result.returncode == 0:
                    Printer.success(f"Initramfs regenerated for {kernel_name}")
                else:
                    Printer.error(f"Error regenerating for {kernel_name}")
        else:
            subprocess.run(["mkinitcpio", "-P"])
            Printer.success("Initramfs regenerated with mkinitcpio -P")
    
    def _check_optimus(self) -> None:
        """Check for hybrid graphics (Optimus)"""
        Printer.info("Checking for hybrid graphics (Optimus)...")
        
        # Check for Intel integrated graphics
        result = subprocess.run(["lspci"], capture_output=True, text=True)
        if "intel" in result.stdout.lower() and "vga" in result.stdout.lower():
            Printer.info("Hybrid graphics detected (NVIDIA + Intel)")
            
            response = input("Install optimus-manager for hybrid graphics? (y/N): ")
            if response.lower() == 'y':
                Printer.info("Installing optimus-manager...")
                subprocess.run(["pacman", "-S", "--noconfirm", "--needed", "optimus-manager"], check=False)
                
                # Configure optimus-manager
                optimus_conf = Path("/etc/optimus-manager/optimus-manager.conf")
                optimus_conf.parent.mkdir(parents=True, exist_ok=True)
                
                config_content = """[optimus]
switching=none
pci_power_control=yes
pci_remove=no
pci_reset=no
auto_logout=yes
startup_mode=nvidia
startup_auto_battery_mode=integrated
startup_auto_extpower_mode=nvidia
"""
                optimus_conf.write_text(config_content)
                
                # Enable service
                subprocess.run(["systemctl", "enable", "optimus-manager.service"], check=False)
                Printer.success("Optimus-manager configured and enabled")
    
    def _create_modprobe_config(self) -> None:
        """Create modprobe configuration for NVIDIA"""
        Printer.info("Configuring nvidia module...")
        
        modprobe_conf = Path("/etc/modprobe.d/nvidia.conf")
        config_content = """# Parameters for NVIDIA module
options nvidia-drm modeset=1
options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0
"""
        modprobe_conf.write_text(config_content)
        Printer.success("Modprobe configuration created")


# ============================================================================
# PACKAGE INSTALLER CLASS
# ============================================================================
class PackageInstaller:
    """Handles package installation from file"""
    
    def __init__(self, system: System):
        self.system = system
    
    def install_from_file(self, pkg_file: Path) -> bool:
        """Install packages from file using paru"""
        if not pkg_file.exists():
            Printer.warning(f"Package list not found: {pkg_file}")
            return False
        
        Printer.info(f"Found package list: {pkg_file}")
        
        # Read packages from file
        packages = self._get_packages_from_file(pkg_file)
        
        if not packages:
            Printer.warning(f"No packages found in {pkg_file}")
            return False
        
        Printer.info(f"Found {len(packages)} packages in {pkg_file}")
        
        # Install packages
        return self._install_packages(packages)
    
    def _get_packages_from_file(self, pkg_file: Path) -> List[str]:
        """Read packages from file, ignoring comments and empty lines"""
        packages = []
        
        with open(pkg_file, 'r') as f:
            for line in f:
                # Remove comments and strip whitespace
                line = line.split('#')[0].strip()
                if line:
                    packages.append(line)
        
        return packages
    
    def _install_packages(self, packages: List[str]) -> bool:
        """Install packages using paru"""
        if not self.system.command_exists("paru"):
            Printer.error("paru not found. Please install AUR helper first.")
            return False
        
        Printer.info(f"Installing {len(packages)} packages...")
        
        result = subprocess.run(
            ["paru", "-S", "--noconfirm", "--needed"] + packages,
            capture_output=False
        )
        
        if result.returncode == 0:
            Printer.success("Packages installed successfully")
            return True
        else:
            Printer.error("Failed to install some packages")
            return False


# ============================================================================
# DOTFILES CLASS
# ============================================================================
class Dotfiles:
    """Handles dotfiles cloning and setup"""
    
    def __init__(self, system: System):
        self.system = system
        self.repo_url = "https://github.com/sakuyma/dotfiles.git"
        self.repo_dir = Path.home() / ".dotfiles"
    
    def clone(self) -> bool:
        """Clone dotfiles repository"""
        Printer.step("Step 3: Cloning dotfiles repository")
        
        # Remove existing directory
        if self.repo_dir.exists():
            Printer.info(f"Removing existing directory: {self.repo_dir}")
            shutil.rmtree(self.repo_dir)
        
        # Clone repository
        Printer.info(f"Cloning repository: {self.repo_url}")
        
        result = subprocess.run(
            ["git", "clone", self.repo_url, str(self.repo_dir)],
            capture_output=True
        )
        
        if result.returncode != 0:
            Printer.error("Failed to clone repository")
            return False
        
        Printer.success(f"Repository cloned successfully to {self.repo_dir}")
        
        # Check for configs
        if (self.repo_dir / "config").exists():
            Printer.success(f"Found configs directory: {self.repo_dir}/config")
        else:
            Printer.warning("No 'config' directory found in repository")
            Printer.info("Looking for dotfiles in other locations...")
            
            # Look for common dotfiles
            dotfiles_found = False
            for pattern in [".zshrc", ".bashrc", ".config"]:
                if any(self.repo_dir.rglob(pattern)):
                    dotfiles_found = True
                    break
            
            if dotfiles_found:
                Printer.success("Found dotfiles in repository root")
            else:
                Printer.error("No dotfiles found in repository")
                return False
        
        return True
    
    def setup_user_environment(self) -> None:
        """Copy configs and set default shell"""
        Printer.step("Step 5: Setting up user environment")
        print()
        
        # Copy configs with stow
        Printer.header("--- Copying Configuration Files ---")
        
        config_dir = self.repo_dir / "config"
        if config_dir.exists():
            os.chdir(config_dir)
            subprocess.run(["stow", ".", "-t", str(self.system.user_home), "--restow"], check=False)
        
        # Set shell to zsh
        self._set_default_shell()
        print()
    
    def _set_default_shell(self) -> None:
        """Set default shell to zsh"""
        Printer.header("--- Setting Default Shell ---")
        
        zsh_path = shutil.which("zsh")
        if zsh_path:
            Printer.info(f"Setting zsh as default shell for {self.system.current_user}")
            
            result = subprocess.run(
                ["chsh", "-s", zsh_path, self.system.current_user],
                capture_output=True
            )
            
            if result.returncode == 0:
                Printer.success("Shell changed to zsh")
            else:
                # Try alternative method via /etc/passwd
                try:
                    passwd_path = Path("/etc/passwd")
                    content = passwd_path.read_text()
                    lines = content.splitlines()
                    
                    for i, line in enumerate(lines):
                        if line.startswith(f"{self.system.current_user}:"):
                            parts = line.split(":")
                            parts[-1] = zsh_path
                            lines[i] = ":".join(parts)
                            break
                    
                    passwd_path.write_text("\n".join(lines) + "\n")
                    Printer.success("Shell changed via /etc/passwd")
                except Exception:
                    Printer.warning("Could not change shell automatically")
                    Printer.info(f"Manual command: sudo chsh -s {zsh_path} {self.system.current_user}")
        else:
            Printer.warning("zsh not installed, skipping shell change")


# ============================================================================
# BOOTLOADER CLASS
# ============================================================================
class Bootloader:
    """Handles bootloader setup (systemd-boot)"""
    
    def __init__(self, system: System):
        self.system = system
    
    def setup(self) -> bool:
        """Setup bootloader"""
        Printer.header("--- Setting up bootloader ---")
        Printer.info("Configuring systemd-boot...")
        
        # Install systemd-boot
        result = subprocess.run(["bootctl", "install"], capture_output=True)
        if result.returncode != 0:
            Printer.error("Failed to install systemd-boot")
            return False
        
        # Create entry for Arch Linux
        entries_dir = Path("/boot/loader/entries")
        entries_dir.mkdir(parents=True, exist_ok=True)
        
        # Read kernel cmdline if exists
        cmdline = ""
        cmdline_file = Path("/etc/kernel/cmdline")
        if cmdline_file.exists():
            cmdline = cmdline_file.read_text().strip()
        else:
            cmdline = "quiet splash"
        
        entry_content = f"""title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=$(findmnt -no PARTUUID /) rw {cmdline}
"""
        entry_file = entries_dir / "arch.conf"
        entry_file.write_text(entry_content)
        
        Printer.success("Bootloader configured successfully")
        return True


# ============================================================================
# REBOOT CLASS
# ============================================================================
class Reboot:
    """Handles reboot countdown and system reboot"""
    
    @staticmethod
    def countdown_and_reboot() -> None:
        """Show reboot countdown and reboot"""
        Printer.step("Step 6: Preparing for reboot")
        print()
        
        Printer.header_box("INSTALLATION COMPLETE")
        print()
        
        Printer.success("All installation steps completed successfully!")
        print()
        
        Printer.info("Summary of actions performed:")
        print("  ✓ Sudo privileges verified")
        print("  ✓ Dotfiles repository cloned")
        print("  ✓ AUR helper installed")
        print("  ✓ NVIDIA drivers installed")
        print("  ✓ Bootloader configured")
        print("  ✓ Packages installed")
        print("  ✓ User configs copied")
        print("  ✓ Default shell set to zsh")
        print()
        
        Printer.warning("System needs to reboot to apply all changes")
        print()
        
        Printer.info("System will reboot in 10 seconds...")
        print()
        
        for i in range(10, 0, -1):
            print(f"\r\033[KTime remaining: {i:2d} seconds (Press Ctrl+C to cancel)", end="")
            sys.stdout.flush()
            time.sleep(1)
        
        print("\r\033[K")
        print()
        
        Printer.info("Rebooting system now...")
        print()
        
        Printer.warning("Press Ctrl+C in the next 3 seconds to cancel reboot...")
        time.sleep(3)
        
        subprocess.run(["reboot"], check=False)


# ============================================================================
# MAIN INSTALLER CLASS
# ============================================================================
class Installer:
    """Main installer orchestrator"""
    
    def __init__(self):
        self.system = System()
        self.aur_helper = AURHelper(self.system)
        self.nvidia = NvidiaDriver(self.system)
        self.package_installer = PackageInstaller(self.system)
        self.dotfiles = Dotfiles(self.system)
        self.bootloader = Bootloader(self.system)
    
    def run(self) -> None:
        """Run main installation"""
        print()
        
        # Initial info
        Printer.header_box("SYSTEM INSTALLATION SCRIPT")
        Printer.info(f"Script launched from: {self.system.launched_by}")
        Printer.info(f"Script directory: {self.system.script_dir}")
        Printer.info(f"Current user: {self.system.current_user}")
        Printer.info(f"User home: {self.system.user_home}")
        print()
        
        # 1. Check sudo
        self.system.check_sudo()
        
        # 2. Change to /tmp
        Printer.step("Step 2: Changing to /tmp directory")
        os.chdir("/tmp")
        Printer.success(f"Current directory: {os.getcwd()}")
        print()
        
        # 3. Clone dotfiles
        if not self.dotfiles.clone():
            Printer.warning("Continuing without dotfiles...")
        print()
        
        # 4. Install AUR helper
        Printer.header("--- Installing AUR Helper ---")
        self.aur_helper.install()
        print()
        
        # 5. NVIDIA drivers
        Printer.header("--- Installing NVIDIA Drivers ---")
        if self.system.check_nvidia_gpu():
            self.nvidia.install()
        else:
            Printer.info("Skipping NVIDIA drivers installation")
        print()
        
        # 6. Bootloader
        self.bootloader.setup()
        print()
        
        # 7. Install packages
        Printer.header("--- Installing Packages ---")
        pkg_file = self.system.script_dir / "pkgs"
        self.package_installer.install_from_file(pkg_file)
        print()
        
        # 8. Setup user environment
        self.dotfiles.setup_user_environment()
        
        # 9. Reboot
        Reboot.countdown_and_reboot()


# ============================================================================
# MAIN ENTRY POINT
# ============================================================================
def signal_handler(sig, frame) -> None:
    """Handle Ctrl+C interrupt"""
    print()
    Printer.warning("Installation interrupted by user")
    Printer.info("Some changes may have been applied partially")
    sys.exit(1)


if __name__ == "__main__":
    import signal
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    installer = Installer()
    installer.run()
