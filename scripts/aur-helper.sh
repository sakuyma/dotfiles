#!/usr/bin/env bash
# Script to install aur helper (paru)

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

# Spinner
dots_animation() {
    local pid=$1
    while kill -0 $pid 2>/dev/null; do
        for dots in "" "." ".." "..."; do
            printf "\r\033[K${BLUE}[INFO]${NC} Installing paru%s" "$dots"
            sleep 0.4
        done
    done
}

# Check sudo privileges
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Superuser privileges required. Run with sudo."
        exit 1
    fi
}

main() {
    if command -v paru &> /dev/null; then
        print_success "AUR helper already installed"
        return
    fi

    print_info "paru not found. Installing AUR helper..."
    print_info "Starting installation..."

    (pacman -S --noconfirm paru 2> /dev/null 1>/dev/null) &
    pid=$!

    dots_animation $pid

    wait $pid

    if command -v paru &> /dev/null; then
        printf "\r\033[K"
        print_success "AUR helper installed successfully"
    else
        printf "\r\033[K"
        print_error "Installation failed"
        exit 1
    fi
}

check_sudo
main "$@"
