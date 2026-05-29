#!/usr/bin/env bash

set -euo pipefail

# Colors
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'
else
    GREEN=''; BLUE=''; YELLOW=''; CYAN=''; MAGENTA=''; BOLD=''; RESET=''
fi

has() { command -v "$1" &>/dev/null; }
is_running() { pgrep -x "$1" &>/dev/null; }

version() {
    local prog="$1"
    local ver=""
    case "$prog" in
        fzf) ver=$(fzf --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        eza) ver=$(eza --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        bat) ver=$(bat --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        btop) ver=$(btop --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        lazygit) ver=$(lazygit --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        git) ver=$(git --version 2>/dev/null | cut -d' ' -f3 | head -1) ;;
        nvim) ver=$(nvim --version 2>/dev/null | head -1 | cut -d' ' -f2) ;;
        tmux) ver=$(tmux -V 2>/dev/null | cut -d' ' -f2) ;;
        zsh) ver=$(zsh --version 2>/dev/null | cut -d' ' -f2) ;;
        ripgrep) ver=$(rg --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        zoxide) ver=$(zoxide --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        *) ver="" ;;
    esac
    echo "${ver:-unknown}"
}

get_config() {
    local prog="$1" file="$2"
    local paths=(
        "$HOME/.config/$prog/$file"
        "$HOME/.$prog/$file"
        "$HOME/.$file"
        "/etc/$prog/$file"
    )
    for p in "${paths[@]}"; do
        if [[ -f "$p" ]]; then echo "$p"; return 0; fi
    done
    return 1
}

echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${BLUE}║              🐧 DYNAMIC SYSTEM DETECTION v3               ║${RESET}"
echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""

# --- OS & Kernel ---
echo -e "${CYAN}► OS & KERNEL${RESET}"
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    echo -e "  ${GREEN}Distribution:${RESET}   ${PRETTY_NAME:-$NAME $VERSION_ID}"
else
    echo -e "  ${GREEN}Distribution:${RESET}   Unknown"
fi
echo -e "  ${GREEN}Kernel:${RESET}          $(uname -r)"
echo -e "  ${GREEN}Architecture:${RESET}     $(uname -m)"
echo -e "  ${GREEN}Uptime:${RESET}           $(uptime -p | sed 's/up //')"
pkgs=$(pacman -Q 2>/dev/null | wc -l)
aur_pkgs=0
has paru && aur_pkgs=$(paru -Q 2>/dev/null | wc -l)
has yay && aur_pkgs=$(yay -Q 2>/dev/null | wc -l)
if [[ $aur_pkgs -gt 0 ]]; then
    echo -e "  ${GREEN}Packages:${RESET}         $pkgs (pacman) + $aur_pkgs (AUR)"
else
    echo -e "  ${GREEN}Packages:${RESET}         $pkgs (pacman)"
fi

# --- Bootloader ---
echo -e "\n${CYAN}► BOOTLOADER${RESET}"
if [[ -d /sys/firmware/efi ]]; then
    echo -e "  ${GREEN}Mode:${RESET} UEFI"
    has bootctl && echo -e "  ${GREEN}Loader:${RESET} systemd-boot"
elif has grub && [[ -d /boot/grub ]]; then
    echo -e "  ${GREEN}Mode:${RESET} BIOS/Legacy"
    echo -e "  ${GREEN}Loader:${RESET} GRUB"
else
    echo -e "  ${GREEN}Mode:${RESET} Unknown"
fi

# --- Init System ---
echo -e "\n${CYAN}► INIT SYSTEM${RESET}"
if ps -p 1 | grep -q systemd; then
    echo -e "  ${GREEN}Init:${RESET} systemd (PID 1)"
    echo -e "  ${GREEN}Version:${RESET} $(systemctl --version | head -1 | cut -d' ' -f2)"
fi

# --- Display ---
echo -e "\n${CYAN}► DISPLAY${RESET}"
if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    echo -e "  ${GREEN}Protocol:${RESET} Wayland"
    if is_running Hyprland; then echo -e "  ${GREEN}Compositor:${RESET} Hyprland"
    elif is_running sway; then echo -e "  ${GREEN}Compositor:${RESET} Sway"
    elif is_running river; then echo -e "  ${GREEN}Compositor:${RESET} River"
    else echo -e "  ${GREEN}Compositor:${RESET} Unknown Wayland compositor"
    fi
elif [[ -n "${DISPLAY:-}" ]]; then
    echo -e "  ${GREEN}Protocol:${RESET} X11"
fi

# --- Terminal ---
echo -e "\n${CYAN}► TERMINAL${RESET}"
[[ -n "${TERM_PROGRAM:-}" ]] && echo -e "  ${GREEN}Program:${RESET} $TERM_PROGRAM"
[[ -n "${TERM:-}" ]] && echo -e "  ${GREEN}Term:${RESET} $TERM"
if is_running foot; then
    echo -e "  ${GREEN}Detected:${RESET} foot"
    get_config foot foot.ini >/dev/null && echo -e "  ${GREEN}Config:${RESET} $(get_config foot foot.ini)"
fi

# --- Shell ---
echo -e "\n${CYAN}► SHELL${RESET}"
echo -e "  ${GREEN}Current:${RESET} $SHELL"
[[ "$SHELL" == *"zsh" ]] && echo -e "  ${GREEN}Version:${RESET} $(zsh --version | cut -d' ' -f2)"
has zinit && echo -e "  ${GREEN}Plugin Mgr:${RESET} zinit"

# --- Prompt ---
echo -e "\n${CYAN}► PROMPT${RESET}"
has starship && echo -e "  ${GREEN}Tool:${RESET} starship"

# --- CLI Tools ---
echo -e "\n${CYAN}► CLI TOOLS${RESET}"
for tool in fzf zoxide rg eza bat btop lazygit tmux git nvim; do
    if has "$tool"; then
        ver=$(version "$tool")
        echo -e "  ${GREEN}✓${RESET} $tool ($ver)"
    fi
done

# --- Tmux ---
echo -e "\n${CYAN}► TMUX${RESET}"
if has tmux; then
    echo -e "  ${GREEN}Installed:${RESET} $(tmux -V 2>/dev/null | cut -d' ' -f2)"
    sessions=$(tmux list-sessions 2>/dev/null | wc -l)
    (( sessions > 0 )) && echo -e "  ${GREEN}Sessions:${RESET} $sessions"
    get_config tmux tmux.conf >/dev/null && echo -e "  ${GREEN}Config:${RESET} $(get_config tmux tmux.conf)"
fi

# --- Editor ---
echo -e "\n${CYAN}► EDITOR${RESET}"
if has nvim; then
    echo -e "  ${GREEN}Neovim:${RESET} $(nvim --version | head -1 | cut -d' ' -f2)"
    get_config nvim init.lua >/dev/null && echo -e "  ${GREEN}Config:${RESET} $(get_config nvim init.lua)"
fi

# --- Browsers ---
echo -e "\n${CYAN}► BROWSERS${RESET}"
has zen-browser && echo -e "  ${GREEN}✓${RESET} zen-browser"
has helium-browser && echo -e "  ${GREEN}✓${RESET} helium-browser"

# --- Backup & Snapshots ---
echo -e "\n${CYAN}► BACKUP & SNAPSHOTS${RESET}"
has pika-backup && echo -e "  ${GREEN}✓${RESET} pika-backup"
has snapper && echo -e "  ${GREEN}✓${RESET} snapper"

# --- ZRAM ---
echo -e "\n${CYAN}► ZRAM${RESET}"
if [[ -d /sys/module/zram ]]; then
    echo -e "  ${GREEN}Status:${RESET} enabled"
    if has zramctl; then
        zramctl 2>/dev/null | tail -n +2 | while read -r line; do
            echo -e "  ${GREEN}Device:${RESET} $line"
        done
    fi
else
    echo -e "  ${YELLOW}Status:${RESET} not enabled"
fi

# --- Firewall ---
echo -e "\n${CYAN}► FIREWALL${RESET}"
if systemctl is-active --quiet firewalld 2>/dev/null; then
    echo -e "  ${GREEN}Status:${RESET} active (firewalld)"
    if has firewall-cmd; then
        echo -e "  ${GREEN}Default zone:${RESET} $(firewall-cmd --get-default-zone 2>/dev/null)"
    fi
fi

# --- System Age ---
echo -e "\n${CYAN}► SYSTEM AGE${RESET}"
if stat -c %w /etc &>/dev/null; then
    install_date=$(stat -c %w /etc | cut -d. -f1 | cut -d' ' -f1,2)
    install_epoch=$(date -d "$install_date" +%s 2>/dev/null || echo 0)
    now_epoch=$(date +%s)
    days=$(( (now_epoch - install_epoch) / 86400 ))
    echo -e "  ${GREEN}Installed:${RESET} $install_date"
    echo -e "  ${GREEN}Age:${RESET} $days days"
fi

# --- Dotfiles ---
echo -e "\n${CYAN}► DOTFILES${RESET}"
if has stow; then
    echo -e "  ${GREEN}Manager:${RESET} GNU Stow"
    dotdir=$(find "$HOME" -maxdepth 2 -type d \( -name ".dotfiles" -o -name "dotfiles" \) 2>/dev/null | head -1)
    [[ -n "$dotdir" ]] && echo -e "  ${GREEN}Repo:${RESET} $dotdir"
fi

echo -e "\n${BOLD}${GREEN}════════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}${GREEN}  ✅ Setup detected dynamically — no hardcoded assumptions${RESET}"
echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════${RESET}"
