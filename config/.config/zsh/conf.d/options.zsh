
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#B4BEFE,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#B4BEFE,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#B4BEFE,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

zstyle ':completion:*:cd:*' tag-order local-directories
zstyle ':completion:*:local-directories' list-colors 'di=34'
zstyle ':completion:*' list-colors \
    'di=34' 'fi=0' 'ex=32' 'ln=36' 'pi=33' 'so=35' \
    'bd=34' 'cd=34' 'su=31' 'sg=31' 'tw=34' 'ow=34'
zstyle ':completion:*:*:*:*' list-colors 'di=34' 'fi=0' 'ex=32' 'ln=36'

zstyle ':completion:*:descriptions' format ''
