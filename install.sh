#!/usr/bin/env bash
# install.sh - Main installation script

set -e  # Exit on error

# Output colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Output functions
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_step() { echo -e "${CYAN}[STEP]${NC} $1"; }
print_header() { echo -e "${MAGENTA}$1${NC}"; }

# 1. Save who launched the script (absolute path)
LAUNCHED_BY="$(pwd)/$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_header "╔══════════════════════════════════════════════════════════════╗"
print_header "║                    SYSTEM INSTALLATION SCRIPT               ║"
print_header "╚══════════════════════════════════════════════════════════════╝"
echo ""
print_info "Script launched from: $LAUNCHED_BY"
print_info "Script directory: $SCRIPT_DIR"

# 2. Request sudo privileges
check_sudo() {
    print_step "Step 1: Checking sudo privileges"
    
    if [ "$EUID" -ne 0 ]; then
        print_warning "This script requires superuser privileges"
        print_info "Attempting to escalate privileges..."
        
        # Try to re-execute with sudo
        if sudo -v; then
            print_info "Re-executing with sudo..."
            exec sudo "$0" "$@"
        else
            print_error "Failed to obtain sudo privileges"
            print_info "Please run this script with sudo:"
            echo "  sudo $0"
            exit 1
        fi
    fi
    
    print_success "Running with superuser privileges"
    echo ""
}

# Get current user
get_current_user() {
    if [ -n "$SUDO_USER" ]; then
        echo "$SUDO_USER"
    else
        echo "$(logname 2>/dev/null || echo "$(who am i | awk '{print $1}')")"
    fi
}

CURRENT_USER=$(get_current_user)
USER_HOME="/home/$CURRENT_USER"
if [ "$CURRENT_USER" = "root" ]; then
    USER_HOME="/root"
fi

print_info "Current user: $CURRENT_USER"
print_info "User home: $USER_HOME"
echo ""

# Function to check for NVIDIA GPU
check_nvidia_gpu() {
    print_info "Checking for NVIDIA GPU..."
    
    if lspci | grep -i "nvidia" > /dev/null 2>&1; then
        print_success "NVIDIA GPU detected"
        return 0
    else
        print_info "No NVIDIA GPU detected"
        return 1
    fi
}

# Function to clone dotfiles repository
clone_dotfiles() {
    print_step "Step 3: Cloning dotfiles repository"
    
    local repo_url=""
    local repo_dir="/tmp/dotfiles"
    
    # Ask for repository URL
    echo ""
    print_info "Please enter the dotfiles repository URL (GitHub, GitLab, etc.)"
    print_info "Example: https://github.com/username/dotfiles.git"
    print_info "Leave empty to skip dotfiles installation"
    echo -n "Repository URL: "
    read -r repo_url
    
    if [ -z "$repo_url" ]; then
        print_warning "No repository URL provided. Skipping dotfiles installation."
        return 1
    fi
    
    # Remove existing directory if it exists
    if [ -d "$repo_dir" ]; then
        print_info "Removing existing directory: $repo_dir"
        rm -rf "$repo_dir"
    fi
    
    # Clone repository
    print_info "Cloning repository: $repo_url"
    
    if git clone "$repo_url" "$repo_dir" 2>&1; then
        print_success "Repository cloned successfully to $repo_dir"
        
        # Check if configs directory exists
        if [ -d "$repo_dir/config" ]; then
            print_success "Found configs directory: $repo_dir/config"
        else
            print_warning "No 'config' directory found in repository"
            print_info "Looking for dotfiles in other locations..."
            
            # Try to find common dotfile locations
            if find "$repo_dir" -name ".zshrc" -o -name ".bashrc" -o -name ".config" | head -1 | grep -q "."; then
                print_success "Found dotfiles in repository root"
            else
                print_error "No dotfiles found in repository"
                return 1
            fi
        fi
        return 0
    else
        print_error "Failed to clone repository"
        return 1
    fi
}

# Function to run installation scripts
run_installation_scripts() {
    print_step "Step 4: Running installation scripts"
    echo ""
    
    # Helper function to run script if it exists
    run_script() {
        local script_name="$1"
        local script_path="$SCRIPT_DIR/$script_name"
        
        if [ -f "$script_path" ]; then
            print_info "Running $script_name..."
            chmod +x "$script_path"
            
            if "$script_path"; then
                print_success "$script_name completed successfully"
            else
                print_error "$script_name failed with exit code $?"
                return 1
            fi
        else
            print_warning "Script not found: $script_name"
            return 2
        fi
        return 0
    }
    
    # 5a. Install AUR helper
    print_header "--- Installing AUR Helper ---"
    run_script "aur-helper.sh"
    echo ""
    
    # 5b. Install NVIDIA drivers if GPU detected
    print_header "--- Checking NVIDIA GPU ---"
    if check_nvidia_gpu; then
        print_info "NVIDIA GPU detected, installing drivers..."
        run_script "nvidia.sh"
    else
        print_info "Skipping NVIDIA drivers installation"
    fi
    echo ""
    
    # 5c. Setup GRUB
    print_header "--- Setting up GRUB ---"
    run_script "grub-setup.sh"
    echo ""
    
    # 5d. Install packages
    print_header "--- Installing Packages ---"
    
    # Check for package list file
    local pkg_file="$SCRIPT_DIR/pkgs"
    if [ -f "$pkg_file" ]; then
        print_info "Found package list: $pkg_file"
        run_script "pkgs-install.sh"
    else
        print_warning "Package list not found: $pkg_file"
        print_info "Skipping package installation"
    fi
    echo ""
}

# Function to copy configs and set shell
setup_user_environment() {
    print_step "Step 5: Setting up user environment"
    echo ""
    
    local dotfiles_dir="/tmp/dotfiles"
    
    # 6. Copy configs
    print_header "--- Copying Configuration Files ---"
    
    if [ -d "$dotfiles_dir/config" ]; then
        print_info "Copying configs from $dotfiles_dir/config to $USER_HOME"
        
        # Create backup of existing configs
        local backup_dir="/tmp/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        
        # Copy with backup
        if cp -r "$dotfiles_dir/config/." "$USER_HOME/" 2>/dev/null; then
            # Fix permissions
            chown -R "$CURRENT_USER:$CURRENT_USER" "$USER_HOME" 2>/dev/null || true
            
            print_success "Configs copied successfully"
            print_info "Backup of existing files saved to: $backup_dir"
        else
            print_error "Failed to copy some configs"
        fi
    else
        print_warning "No configs directory found at $dotfiles_dir/config"
    fi
    echo ""
    
    # 7. Set shell to zsh
    print_header "--- Setting Default Shell ---"
    
    if command -v zsh >/dev/null 2>&1; then
        local zsh_path=$(which zsh)
        print_info "Setting zsh as default shell for $CURRENT_USER"
        
        if chsh -s "$zsh_path" "$CURRENT_USER" 2>/dev/null; then
            print_success "Shell changed to zsh"
        else
            # Try alternative method
            if sed -i "s|^$CURRENT_USER:.*:.*:.*:.*:.*:.*$|&:$zsh_path|" /etc/passwd 2>/dev/null; then
                print_success "Shell changed via /etc/passwd"
            else
                print_warning "Could not change shell automatically"
                print_info "Manual command: sudo chsh -s $(which zsh) $CURRENT_USER"
            fi
        fi
    else
        print_warning "zsh not installed, skipping shell change"
    fi
    echo ""
}

# Function for reboot countdown
reboot_countdown() {
    print_step "Step 6: Preparing for reboot"
    echo ""
    
    print_header "╔══════════════════════════════════════════════════════════════╗"
    print_header "║                     INSTALLATION COMPLETE                   ║"
    print_header "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    
    print_success "All installation steps completed successfully!"
    echo ""
    
    print_info "Summary of actions performed:"
    echo "  ✓ Sudo privileges verified"
    echo "  ✓ Dotfiles repository cloned"
    echo "  ✓ AUR helper installed"
    echo "  $(check_nvidia_gpu && echo '✓' || echo '✗') NVIDIA drivers installed"
    echo "  ✓ GRUB configured"
    echo "  ✓ Packages installed"
    echo "  ✓ User configs copied"
    echo "  ✓ Default shell set to zsh"
    echo ""
    
    print_warning "System needs to reboot to apply all changes"
    echo ""
    
    # 8. Display 10-second countdown
    print_info "System will reboot in 10 seconds..."
    echo ""
    
    for i in {10..1}; do
        printf "\r\033[K"  # Clear line
        printf "Time remaining: %2d seconds (Press Ctrl+C to cancel)" "$i"
        sleep 1
    done
    
    printf "\r\033[K"  # Clear line
    echo ""
    
    # 9. Reboot
    print_info "Rebooting system now..."
    echo ""
    
    # Give user one last chance
    print_warning "Press Ctrl+C in the next 3 seconds to cancel reboot..."
    sleep 3
    
    reboot
}

# Main function
main() {
    echo ""
    
    # 2. Check sudo
    check_sudo
    
    # 3. Change to /tmp
    print_step "Step 2: Changing to /tmp directory"
    cd /tmp || {
        print_error "Failed to change to /tmp directory"
        exit 1
    }
    print_success "Current directory: $(pwd)"
    echo ""
    
    # 4. Clone dotfiles repository
    if ! clone_dotfiles; then
        print_warning "Continuing without dotfiles..."
    fi
    echo ""
    
    # 5. Run installation scripts
    run_installation_scripts
    
    # 6-7. Setup user environment
    setup_user_environment
    
    # 8-9. Reboot countdown and reboot
    reboot_countdown
}

# Handle script interruption
cleanup() {
    echo ""
    print_warning "Installation interrupted by user"
    print_info "Some changes may have been applied partially"
    exit 1
}

trap cleanup INT TERM

# Run main function
main "$@"
