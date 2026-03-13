paths=(
    "/usr/local/opt/openjdk/bin"
    "/home/user/.spicetify"
    "$HOME/.local/bin"
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

