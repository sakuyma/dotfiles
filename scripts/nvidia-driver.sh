#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_message() {
    echo -e "${BLUE}[NVIDIA]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to add NVIDIA modules to mkinitcpio.conf
add_nvidia_modules_to_mkinitcpio() {
    local mkinitcpio_conf="/etc/mkinitcpio.conf"
    local backup_file="${mkinitcpio_conf}.bak.$(date +%Y%m%d_%H%M%S)"
    
    print_message "Configuring mkinitcpio for NVIDIA modules..."
    
    # Create backup
    cp "$mkinitcpio_conf" "$backup_file"
    print_message "Backup created: $backup_file"
    
    # Check if NVIDIA modules already exist
    if grep -q "MODULES.*nvidia" "$mkinitcpio_conf"; then
        print_message "NVIDIA modules already present in mkinitcpio.conf"
        
        # Check for all required modules
        local missing_modules=()
        [[ ! $(grep "MODULES.*i915\b" "$mkinitcpio_conf") ]] && missing_modules+=("i915")
        [[ ! $(grep "MODULES.*nvidia\b" "$mkinitcpio_conf") ]] && missing_modules+=("nvidia")
        [[ ! $(grep "MODULES.*nvidia_modeset\b" "$mkinitcpio_conf") ]] && missing_modules+=("nvidia_modeset")
        [[ ! $(grep "MODULES.*nvidia_uvm\b" "$mkinitcpio_conf") ]] && missing_modules+=("nvidia_uvm")
        [[ ! $(grep "MODULES.*nvidia_drm\b" "$mkinitcpio_conf") ]] && missing_modules+=("nvidia_drm")
       
        if [ ${#missing_modules[@]} -eq 0 ]; then
            print_success "All NVIDIA modules already configured"
            return 0
        else
            print_message "Adding missing modules: ${missing_modules[*]}"
            # Add missing modules
            sed -i "s/^MODULES=(\(.*\))/MODULES=(\1 ${missing_modules[*]})/" "$mkinitcpio_conf"
        fi
    else
        # Find MODULES= line and add NVIDIA modules
        if grep -q "^MODULES=" "$mkinitcpio_conf"; then
            print_message "Adding NVIDIA modules to existing MODULES..."
            sed -i "s/^MODULES=(\(.*\))/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" "$mkinitcpio_conf"
        else
            print_message "Adding MODULES line with NVIDIA modules..."
            # If MODULES line not found, add it after comment block
            sed -i "/^#MODULES=/a MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)" "$mkinitcpio_conf"
        fi
    fi
    
    # Check for nouveau driver modeset option
    if grep -q "MODULES.*nouveau" "$mkinitcpio_conf"; then
        print_warning "Nouveau module detected. Recommended to disable it for NVIDIA."
        read -p "Disable nouveau module? (y/N): " disable_nouveau
        if [[ "$disable_nouveau" =~ ^[Yy]$ ]]; then
            sed -i 's/\(MODULES=(.*\)nouveau\(.*)\)/\1\2/' "$mkinitcpio_conf"
            sed -i 's/nouveau //g' "$mkinitcpio_conf"
            sed -i 's/  / /g' "$mkinitcpio_conf"
            sed -i 's/ )/)/' "$mkinitcpio_conf"
            sed -i 's/( /(/' "$mkinitcpio_conf"
            print_success "Nouveau module disabled"
        fi
    fi
    
    # Add kernel parameters for NVIDIA drivers (optional)
    add_kernel_parameters
    
    # Regenerate initramfs
    regenerate_initramfs
}

# Function to add kernel parameters
add_kernel_parameters() {
    local grub_cfg="/etc/default/grub"
    
    print_message "Checking kernel parameters for NVIDIA..."
    
    # Check if parameters already added
    if ! grep -q "nvidia-drm.modeset=1" "$grub_cfg"; then
        print_message "Adding kernel parameters for NVIDIA..."
        
        # Create grub backup
        cp "$grub_cfg" "${grub_cfg}.bak.$(date +%Y%m%d_%H%M%S)"
        
        # Add parameters to GRUB_CMDLINE_LINUX_DEFAULT
        if grep -q "^GRUB_CMDLINE_LINUX_DEFAULT=" "$grub_cfg"; then
            sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1"/' "$grub_cfg"
        else
            echo 'GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"' >> "$grub_cfg"
        fi
        
        # Update GRUB configuration
        if command -v update-grub &> /dev/null; then
            update-grub
        elif command -v grub-mkconfig &> /dev/null; then
            grub-mkconfig -o /boot/grub/grub.cfg
        elif [ -f "/boot/grub/grub.cfg" ]; then
            print_warning "Update GRUB configuration manually"
        fi
    else
        print_message "Kernel parameters for NVIDIA already configured"
    fi
}

# Function to regenerate initramfs
regenerate_initramfs() {
    print_message "Regenerating initramfs..."
    
    # Determine kernel image name
    local kernel_img=""
    if [ -f "/boot/initramfs-linux.img" ]; then
        kernel_img="linux"
    elif [ -f "/boot/initramfs-linux-lts.img" ]; then
        kernel_img="linux-lts"
    else
        # Find available images
        for img in /boot/initramfs-*.img; do
            if [ -f "$img" ]; then
                kernel_img=$(basename "$img" | sed 's/^initramfs-//' | sed 's/\.img$//')
                break
            fi
        done
    fi
    
    if [ -n "$kernel_img" ]; then
        print_message "Regenerating initramfs for kernel: $kernel_img"
        
        # Try different regeneration methods
        if command -v mkinitcpio &> /dev/null; then
            if mkinitcpio -p "$kernel_img"; then
                print_success "Initramfs successfully regenerated"
            else
                print_error "Error regenerating initramfs"
                return 1
            fi
        elif command -v dracut &> /dev/null; then
            dracut --force
            print_success "Initramfs regenerated with dracut"
        else
            print_error "mkinitcpio or dracut not found"
            print_warning "Update initramfs manually: mkinitcpio -P"
            return 1
        fi
    else
        print_error "Could not determine kernel image for initramfs regeneration"
        print_warning "Update initramfs manually: mkinitcpio -P"
        return 1
    fi
}

# Function to check and install required packages
install_nvidia_packages() {
    print_message "Installing NVIDIA packages..."
    
    # Base NVIDIA packages
    local base_packages=(
        "nvidia"
        "nvidia-utils"
        "nvidia-settings"
        "nvidia-prime"
    )
    
    # VA-API support packages (hardware video acceleration)
    local vaapi_packages=(
        "libva-utils"
        "libva-mesa-driver"
    )
    
    # Check if drivers already installed
    if pacman -Qs nvidia > /dev/null 2>&1; then
        print_message "NVIDIA drivers already installed. Updating..."
        pacman -Syu --noconfirm --needed "${base_packages[@]}"
    else
        print_message "Installing NVIDIA drivers..."
        pacman -S --noconfirm --needed "${base_packages[@]}"
    fi
    
    # Install hardware video acceleration packages
    print_message "Installing hardware video acceleration packages..."
    pacman -S --noconfirm --needed "${vaapi_packages[@]}"
    
    # Check architecture for additional packages
    if uname -m | grep -q "64"; then
        print_message "Installing 32-bit libraries (for Steam and other applications)..."
        pacman -S --noconfirm --needed lib32-nvidia-utils
    fi
    
    # Install CUDA toolkit (optional)
    read -p "Install CUDA toolkit for GPU computing? (y/N): " install_cuda
    if [[ "$install_cuda" =~ ^[Yy]$ ]]; then
        print_message "Installing CUDA toolkit..."
        pacman -S --noconfirm --needed cuda
    fi
}

# Function to check for hybrid graphics (Optimus)
check_optimus() {
    print_message "Checking for hybrid graphics (Optimus)..."
    
    # Check for integrated Intel graphics
    if lspci | grep -i "vga.*intel" > /dev/null 2>&1; then
        print_message "Hybrid graphics detected (NVIDIA + Intel)"
        
        read -p "Install optimus-manager for hybrid graphics? (y/N): " install_optimus
        if [[ "$install_optimus" =~ ^[Yy]$ ]]; then
            print_message "Installing optimus-manager..."
            pacman -S --noconfirm --needed optimus-manager
            
            # Configure optimus-manager
            local optimus_conf="/etc/optimus-manager/optimus-manager.conf"
            if [ ! -f "$optimus_conf" ]; then
                mkdir -p /etc/optimus-manager
                cat > "$optimus_conf" << EOF
[optimus]
switching=none
pci_power_control=yes
pci_remove=no
pci_reset=no
auto_logout=yes
startup_mode=nvidia
startup_auto_battery_mode=integrated
startup_auto_extpower_mode=nvidia
EOF
            fi
            
            # Enable service
            systemctl enable optimus-manager.service
            print_success "Optimus-manager configured and enabled"
        fi
    fi
}

# Main function
main() {
    print_message "=== NVIDIA Driver Installation and Configuration ==="
    
    # Check for NVIDIA graphics card
    if ! lspci | grep -i nvidia > /dev/null 2>&1; then
        print_error "NVIDIA graphics card not detected!"
        exit 1
    fi
    
    print_message "NVIDIA graphics card detected"
    
    # 1. Install packages
    install_nvidia_packages
    
    # 2. Configure mkinitcpio
    add_nvidia_modules_to_mkinitcpio
    
    # 3. Check for hybrid graphics
    check_optimus
    
    # 5. Create modprobe configuration file
    print_message "Configuring nvidia module..."
    local modprobe_conf="/etc/modprobe.d/nvidia.conf"
    cat > "$modprobe_conf" << EOF
# Parameters for NVIDIA module
options nvidia-drm modeset=1
options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0
EOF
    
    print_success "=== NVIDIA driver installation completed ==="
    echo ""
    print_message "REBOOT REQUIRED to apply changes"
    echo ""
    print_message "After reboot, verify installation:"
    print_message "1. nvidia-smi - graphics card status"
    print_message "2. glxinfo | grep OpenGL - OpenGL information"
    print_message "3. nvidia-settings - NVIDIA settings"
    
    # Offer to reboot
    read -p "Reboot now? (y/N): " reboot_now
    if [[ "$reboot_now" =~ ^[Yy]$ ]]; then
        print_message "Rebooting system..."
        reboot
    fi
}

# Run with superuser privileges
if [ "$EUID" -ne 0 ]; then
    print_error "This script requires superuser privileges. Run with sudo."
    exit 1
fi

main "$@"
