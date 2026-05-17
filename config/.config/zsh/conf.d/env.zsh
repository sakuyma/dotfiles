#!/usr/bin/env zsh
paths=(
    "/usr/local/opt/openjdk/bin"
    # "$HOME/.cargo/bin"
    "$HOME/.spicetify"
    "$HOME/.local/bin"
    "$HOME/.config/zsh/scripts"
    "/bin"
    "/usr/bin" 
    "/usr/local/bin"
    "/sbin"
    "$PATH"

)
export PATH="${(j[:])paths}"

export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"
export FETCH="fastfetch"

export LANG=en_US.utf8
export LC_ALL=en_US.utf8
