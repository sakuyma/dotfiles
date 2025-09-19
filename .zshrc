typeset -g POWERLEVEL9K_INSTANT_PROMT=off
typeset -g POWERLEVEL10K_INSTANT_PROMT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export KUBECONFIG=/Users/alaricode/.kube/purple-cluster_kubeconfig.yaml
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git z docker zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting history)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='mvim'
if [ -f '/Users/alaricode/vk-cloud-solutions/path.bash.inc' ]; then source '/Users/alaricode/vk-cloud-solutions/path.bash.inc'; fi

# bun completions
[ -s "/Users/alaricode/.bun/_bun" ] && source "/Users/alaricode/.bun/_bun"
alias ls="eza --tree --level=1 --icons=always --no-time --no-user --no-permissions"

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/Users/alaricode/.cargo/bin"
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:${PATH}
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias ls="lsd"
alias cls="clear"
alias sn"sudo nvim -u ~/.config/nvim/init.lua"
alias n="nvim"
alias clock="tty-clock"
alias s='sudo'

alias ff="fastfetch"
alias pf="bash ~/apps/pfetch/pfetch"
alias sff="fastfetch --config ~/.config/fastfetch/config_small.jsonc"
alias colors="colors.sh"

alias poff="systemctl poweroff --no-wall"
alias rbt="systemctl reboot --no-wall"

alias misha="python ~/apps/python/1/main.py" 

alias exit="sudo systemctl start sddm && hyprctl dispatch exit"
alias powermenu="sh ~/.config/rofi/powermenu.sh"
alias launcher="sh ~/.config/rofi/launcher.sh"
