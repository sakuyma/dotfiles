ZSHRC_START_TIME=$(date +%s.%N)

# ========== AUTO PLUGINS INSTALLATION  ========== # 
if [[ ! -r "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# ========== THEME SETTINGS ========== # 
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMT=quiet
typeset -g POWERLEVEL10K_INSTANT_PROMT=off
ZSH_THEME="powerlevel10k/powerlevel10k"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#B4BEFE,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#B4BEFE,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#B4BEFE,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# ========== oh-my-zsh ========== # 
export ZSH="$HOME/.oh-my-zsh"
plugins=(git z docker zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting history) 


autoload -Uz compinit
compinit -C
source $ZSH/oh-my-zsh.sh

paths=(
    "/usr/local/opt/openjdk/bin"
    "/home/user/.spicetify"
    "$HOME/.bun/bin"
    "/bin"
    "/usr/bin" 
    "/usr/local/bin"
    "/sbin"
    "$PATH"
)
export PATH="${(j[:])paths}"

export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"
export FETCH="pfetch"

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# ========== ALIASES  ========== # 
function starttime() {
  echo "⏱️  .zsh loaded in ${ZSHRC_DURATION}s"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias calc="gcalccmd"
alias c="clear"
alias clock="tty-clock"
alias ls='lsd'
alias n='nvim'
alias src='source'
alias inv='nvim $(fzf --tmux top,60%  -m --preview="bat --color=always {}")'
alias killfzf='kill -9 $(ps aux | fzf-tmux --height 60% --multi | awk "{print \$2}")'
alias tmux-del='tmux list-sessions -F "#{session_name}" | grep -v "^default$"| xargs -I {} tmux kill-session -t {}'
alias i='paru -S'

alias ff="fastfetch"
alias pf="pfetch"


alias poff="systemctl poweroff --no-wall"
alias rbt="systemctl reboot --no-wall"
alias exit="sudo systemctl start sddm && hyprctl dispatch exit"

bindkey -r '\ec'
bindkey '^[f' fzf-cd-widget

# ========== AUTOSTART  ========== # 
if [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]]; then
  cd ~
  clear
  $FETCH
fi

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

ZSHRC_END_TIME=$(date +%s.%N)
ZSHRC_DURATION=$(($ZSHRC_END_TIME - $ZSHRC_START_TIME))
