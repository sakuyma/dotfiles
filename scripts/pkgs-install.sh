#!/usr/bin/env bash
# Script to install packages from a file via paru without prompts

set -e  # Exit on error

# Output colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output functions
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check sudo privileges
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Superuser privileges required. Run with sudo."
        exit 1
    fi
}

# Install AUR helper if not present
install_aur_helper() {
    print_info "paru not found. Installing AUR helper..."
    
    # Check if aur-helper.sh exists
    if [ -f "${SCRIPT_DIR}/aur-helper.sh" ]; then
        print_info "Running aur-helper.sh..."
        chmod +x "${SCRIPT_DIR}/aur-helper.sh"
        "${SCRIPT_DIR}/aur-helper.sh"
        
        # Verify installation
        if command -v paru &> /dev/null; then
            print_success "AUR helper installed successfully"
        else
            print_error "Failed to install AUR helper"
            exit 1
        fi
    elif [ -f "./aur-helper.sh" ]; then
        print_info "Running ./aur-helper.sh..."
        chmod +x ./aur-helper.sh
        ./aur-helper.sh
        
        if command -v paru &> /dev/null; then
            print_success "AUR helper installed successfully"
        else
            print_error "Failed to install AUR helper"
            exit 1
        fi
    else
        print_error "aur-helper.sh not found in ${SCRIPT_DIR} or current directory"
        print_info "Installing paru manually..."
        
        # Manual paru installation
        install_dependencies() {
            pacman -S --noconfirm --needed base-devel git
        }
        
        build_paru() {
            local temp_dir=$(mktemp -d)
            cd "$temp_dir"
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm
            cd /
            rm -rf "$temp_dir"
        }
        
        install_dependencies
        build_paru
        
        if command -v paru &> /dev/null; then
            print_success "paru installed manually"
        else
            print_error "Manual paru installation failed"
            exit 1
        fi
    fi
}

# Check if paru is installed, install if not
check_paru() {
    if ! command -v paru &> /dev/null; then
        print_warning "paru is not installed"
        install_aur_helper
    else
        print_info "paru is already installed"
    fi
}

# Check if a package is already installed
pkg_installed() {
    pacman -Qi "$1" &> /dev/null
}

# Check if package is available in official repositories
pkg_available() {
    pacman -Si "$1" &> /dev/null || return 1
}

# Check if package is available in AUR
aur_available() {
    paru -Si "$1" &> /dev/null || return 1
}

# Get packages list from file
get_packages_from_file() {
    local file="$1"
    local packages=()
    
    if [ ! -f "$file" ]; then
        print_error "File $file not found!"
        exit 1
    fi
    
    # Read file, ignore comments and empty lines
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Remove comments and trim whitespace
        local pkg=$(echo "$line" | sed 's/#.*$//' | xargs)
        
        if [ -n "$pkg" ]; then
            packages+=("$pkg")
        fi
    done < "$file"
    
    echo "${packages[@]}"
}

# Install packages function
install_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        return 0
    fi
    
    print_info "Installing ${#packages[@]} packages..."
    paru -S --noconfirm --needed "${packages[@]}"
    
    if [ $? -eq 0 ]; then
        print_success "Packages installed successfully"
        return 0
    else
        print_error "Failed to install some packages"
        return 1
    fi
}

# Main function
main() {
    local PKG_FILE="${1:-pkgs}"  # Package list file (default: pkgs)
    local ALL_PKGS=()
    local TO_INSTALL=()
    
    print_info "Starting package installation from file: $PKG_FILE"
    
    # Get all packages from file
    ALL_PKGS=($(get_packages_from_file "$PKG_FILE"))
    
    if [ ${#ALL_PKGS[@]} -eq 0 ]; then
        print_warning "No packages found in $PKG_FILE for installation"
        exit 0
    fi
    
    print_info "Found ${#ALL_PKGS[@]} packages in $PKG_FILE"
    
    # Filter out already installed packages
    for pkg in "${ALL_PKGS[@]}"; do
        if pkg_installed "$pkg"; then
            print_info "Already installed: $pkg"
        else
            TO_INSTALL+=("$pkg")
        fi
    done
    
    # Install packages
    if [ ${#TO_INSTALL[@]} -gt 0 ]; then
        print_info "Packages to install: ${TO_INSTALL[*]}"
        install_packages "${TO_INSTALL[@]}"
    else
        print_info "All packages are already installed"
    fi
    
    # Summary
    echo ""
    print_success "=== Installation completed ==="
    print_info "Summary:"
    print_info "  Total packages in list: ${#ALL_PKGS[@]}"
    print_info "  Already installed: $(( ${#ALL_PKGS[@]} - ${#TO_INSTALL[@]} ))"
    print_info "  Newly installed: ${#TO_INSTALL[@]}"
}

# Checks and execution
check_sudo
check_paru
main "$@"
