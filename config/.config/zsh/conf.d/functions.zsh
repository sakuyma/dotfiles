function starttime() {
  echo "zsh loaded in ${ZSHRC_DURATION}s"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
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
