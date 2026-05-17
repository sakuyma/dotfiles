function starttime() {
    local end_time=$EPOCHREALTIME
    local duration=$((end_time - ZSHRC_START_TIME))
    print -P "%F{green}✓ zsh loaded in ${(f)duration} seconds%f"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function mkcd() {
    if [ $# -eq 0 ]; then
        echo "Usage: mkcd <directory> [directory2 ...]"
        echo "  Creates directory(ies) and cd's into the last one"
        return 1
    fi
    
    local target_dir="${@: -1}"

    for dir in "$@"; do 
        if [ -e "$dir" ] && [ ! -d "$dir" ]; then
            echo "Error: '$dir' exists but not a directory"
            return 1
        fi 
    done 

    mkdir -p "$@" || return 1

    if cd "$target_dir"; then
        return 0
    else
        return 1
    fi
}

function blame() {
    local system="$(systemd-analyze blame)"
    local grepl="grep -v \"\\.device\""
    
    if command -v bat >/dev/null 2>&1; then
        local print="bat"
    else
        local print="cat"
    fi 

    echo "$system" | eval "$grepl" | $print
}
