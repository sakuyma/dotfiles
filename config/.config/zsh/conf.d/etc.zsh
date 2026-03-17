#!/usr/bin/env zsh

# ========== PLUGIN MANAGER ========== #
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ========== OH-MY-ZSH LIBRARIES ========== #
zinit wait"0" lucid for \
    OMZL::history.zsh \
    OMZL::completion.zsh \
    OMZL::key-bindings.zsh \
    OMZL::git.zsh \
    OMZL::directories.zsh

# ========== OH-MY-ZSH PLUGINS ========== #
zinit wait"1" lucid for \
    OMZP::git \
    OMZP::docker \
    OMZP::docker-compose \
    OMZP::history \
    OMZP::sudo \
    OMZP::archlinux \
    OMZP::systemd

# ========== EXTERNAL PLUGINS ========== #
zinit wait"1" lucid atload"_zsh_autosuggest_start" for \
    zsh-users/zsh-autosuggestions

zinit wait"1" lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" for \
    zdharma-continuum/fast-syntax-highlighting

zinit wait"0" lucid for \
    zsh-users/zsh-completions \
    zsh-users/zsh-history-substring-search \
    ael-code/zsh-colored-man-pages

# ========== POST-PLUGIN SETUP ========== #
autoload -Uz compinit
compinit -C

zstyle ':completion:*' list-colors 'di=34' 'ex=32' 'fi=0' 'ln=36'
zstyle ':completion:*' format '%B%F{34}%d%f%b'
zstyle ':completion:*:descriptions' format '%B%F{34}-- %d --%f%b'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

zstyle ':completion:*' menu select
