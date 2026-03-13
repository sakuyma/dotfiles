alias calc="gcalccmd"
alias c="clear"
alias clock="tty-clock"
alias ls="lsd"
alias n="nvim"

alias src='source'
alias inv='nvim $(fzf --tmux top,60%  -m --preview="bat --color=always {}")'
alias killfzf='kill -9 $(ps aux | fzf-tmux --height 60% --multi | awk "{print \$2}")'
alias tmux-del='tmux list-sessions -F "#{session_name}" | grep -v "^default$"| xargs -I {} tmux kill-session -t {}'
alias i='paru -S'

alias ff="fastfetch"
alias pf="pfetch"
alias icat="kitten icat"

alias poff="systemctl poweroff --no-wall"
alias rbt="systemctl reboot --no-wall"
alias logout="loginctl terminate-session $(loginctl | rg $(whoami) | awk '{print $1}')"

