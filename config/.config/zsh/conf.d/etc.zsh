#!/usr/bin/env zsh
# ========== POST-PLUGIN SETUP ========== #
autoload -Uz compinit
compinit -C

zstyle ':completion:*' list-colors 'di=34' 'ex=32' 'fi=0' 'ln=36'
zstyle ':completion:*' format '%B%F{34}%d%f%b'
zstyle ':completion:*:descriptions' format '%B%F{34}-- %d --%f%b'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

zstyle ':completion:*' menu select

bindkey -v

bindkey -M vicmd 'h' vi-backward-char
bindkey -M vicmd 'l' vi-forward-char
bindkey -M vicmd 'j' vi-down-line-or-history
bindkey -M vicmd 'k' vi-up-line-or-history
