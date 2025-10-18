if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMT=quiet
typeset -g POWERLEVEL10K_INSTANT_PROMT=off

export ZSH="$HOME/.oh-my-zsh"
export KUBECONFIG=/Users/alaricode/.kube/purple-cluster_kubeconfig.yaml
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git z docker zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting history)

source $ZSH/oh-my-zsh.sh
if [ -f '/Users/alaricode/vk-cloud-solutions/path.bash.inc' ]; then source '/Users/alaricode/vk-cloud-solutions/path.bash.inc'; fi

[ -s "/Users/alaricode/.bun/_bun" ] && source "/Users/alaricode/.bun/_bun"
export PATH=$PATH:/home/user/.spicetify
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/Users/alaricode/.cargo/bin"
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:${PATH}
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export EDITOR="nvim"

eval "$(fzf --zsh)"
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function htt() {
  httpyac $1 --json -a | jq -r ".requests[0].response.body" | jq | bat --language=json
}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias calc="gcalccmd"
alias cls="clear"
alias clock="tty-clock"
alias ls='lsd'

alias ff="fastfetch"
alias pf="pfetch"
alias sff="fastfetch --config ~/.config/fastfetch/config_small.jsonc"
alias pls="sudo"
alias fucking="sudo"

alias poff="systemctl poweroff --no-wall"
alias rbt="systemctl reboot --no-wall"
alias zapret="sudo /opt/zapret/init.d./sysv/zapret"
alias exit="sudo systemctl start sddm && hyprctl dispatch exit"

if [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]]; then
  cd ~
  clear
  pfetch
fi
