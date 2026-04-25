alias calc="gcalccmd"
alias c="clear"
alias cls="clear"
alias clock="tty-clock"
alias ls="eza --icons"
alias tree="ls --tree"
alias n="nvim"

alias src='source'
alias inv='nvim $(fzf --tmux top,60%  -m --preview="bat --color=always {}")'
alias killfzf='kill -9 $(ps aux | fzf-tmux --height 60% --multi | awk "{print \$2}")'
alias tmux-del='tmux list-sessions -F "#{session_name}" | grep -v "^default$"| xargs -I {} tmux kill-session -t {}'
alias i='paru -S'

alias ff="fastfetch"
alias pf="pfetch"
alias nf="nitch"
alias icat="kitten icat"

alias poff="systemctl poweroff --no-wall"
alias rbt="systemctl reboot --no-wall"
alias logout="loginctl terminate-session $(loginctl | rg $(whoami) | awk '{print $1}')"
alias cd="z"
alias sudo="sudo-rs"
alias su="su-rs"

alias note="yazi ~/Obsidian/"

alias daily="nvim ~/Obsidian/Life/game/Quests/Daily/$(date +%Y-%m-%d).md"
