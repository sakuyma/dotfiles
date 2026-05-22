
# zshrc

```
export ZSHRC_START_TIME=$EPOCHREALTIME

export ZSH_CONFIG="$HOME/.config/zsh"
export ZSH_CONFD="$ZSH_CONFIG/conf.d"

zsh_modules=(
    "$ZSH_CONFD/syntax.zsh"
    "$ZSH_CONFD/plugins.zsh"
    "$ZSH_CONFD/options.zsh"
    "$ZSH_CONFD/env.zsh"
    "$ZSH_CONFD/hooks.zsh"
    "$ZSH_CONFD/functions.zsh"
    "$ZSH_CONFD/aliases.zsh"
    "$ZSH_CONFD/etc.zsh"
)

# Loading 
for module in "${zsh_modules[@]}"; do
    [[ -f "$module" ]] && source "$module"
done

# export ZSH_LOAD_TIME=$(printf "%.3f" $(($EPOCHREALTIME - $ZSHRC_START_TIME)))
# echo "DEBUG: ZSH_LOAD_TIME = $ZSH_LOAD_TIME"

```

# scripts/mkcd

```

```

# scripts/matrix

```
#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# File Purpose
#   A high-performance terminal implementation of the "Digital Rain" effect.
#
# Problems Solved
#   - Visualizes the classic Matrix effect using optimized terminal escape codes.
#   - Solves the problem of multibyte character rendering in standard AWK by
#     defaulting to GAWK (GNU Awk) for Japanese character support.
#   - Manages terminal state to prevent artifacts (hides cursor, restores colors).
#
# Features / Responsibilities
#   - Unicode Support: Utilizes Half-width Katakana for an authentic look.
#   - Dynamic Resizing: Adapts to current terminal dimensions via 'tput'.
#   - High-Speed Refresh: Controlled by a non-blocking Zsh 'read' loop.
#   - Smooth Animation: Implements "Tail Erase" logic to prevent screen smearing.
#
# Usage Notes
#   - Press 'q' or 'Ctrl+C' to terminate and restore terminal settings.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Environment Sandbox

# emulate -L zsh: Ensures function-local scope for options.
# no_notify/no_monitor: Prevents background job status from breaking the UI.
emulate -L zsh
setopt localoptions no_notify no_monitor

# ------------------------------------------------------------------------------
# Dependency Check

local awk_cmd="awk"
local use_unicode="0"

# !!! CRITICAL: Character Encoding
# GAWK is required to handle the multibyte Katakana string correctly.
# Standard POSIX awk may treat a multibyte char as multiple columns.
if (( $+commands[gawk] )); then
    awk_cmd="gawk"
    use_unicode="1"
else
    print -P "${COLOR[YELLOW]}[WARNING]${COLOR[RESET]} 'gawk' not found. Falling back to ASCII mode."
    print -P "          Install gawk (${COLOR[UNDERLINE]}brew install gawk${COLOR[RESET]}) for Japanese characters."
    read -k 1 -t 2  # Pause briefly so user sees the warning
fi

# ------------------------------------------------------------------------------
# Terminal State Management

# ---- SAFE: Ensure terminal is restored on exit
# cnorm: restores cursor | sgr0: resets colors | clear: wipes screen.
trap 'tput cnorm; tput sgr0; clear; return' INT TERM EXIT

tput civis  # Hide the cursor for better immersion
clear       # Initial screen wipe

# ------------------------------------------------------------------------------
# Character Set Selection

# Half-width Katakana (standard for the Matrix effect)
local chars_japanese="ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ0123456789:・.=*+-<>"
local chars_ascii="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"

local selected_chars="$chars_ascii"
[[ "$use_unicode" == "1" ]] && selected_chars="$chars_japanese"

# ------------------------------------------------------------------------------
# Execution Loop (The Clock)

# We use a Zsh while loop as the "metronome". Every 'print' sends a pulse to AWK.
while :; do
    # read -t 0.05: Controls the framerate (approx 20 FPS).
    # We read from /dev/tty to ensure 'q' works even if we are piping.
    read -s -k 1 -t 0.05 key < /dev/tty 2>/dev/null
    if [[ "$key" == "q" ]]; then break; fi
    print
done | LC_ALL=en_US.UTF-8 $awk_cmd \
    -v lines="$(tput lines)" \
    -v cols="$(tput cols)" \
    -v chars="$selected_chars" \
    '
BEGIN {
    srand();
    len_chars = length(chars);

    # --- Complex Logic: Column Initialization ---
    # y[c]: current vertical position of the head.
    # l[c]: the length of the green tail for this column.
    # We start with negative Y values to stagger the entry of streams.
    for (c = 1; c <= cols; c++) {
        y[c] = -1 * int(rand() * 50);
        l[c] = int(rand() * 15) + 5;
    }
}

{
    # For every "tick" received from the Zsh loop:
    for (c = 1; c <= cols; c++) {

        # --- Complex Logic: Boundary & Reset ---
        # If the tail has completely left the screen, or by random chance (0.02),
        # we reset the stream to the top.
        if (y[c] > lines + l[c] || (y[c] < 0 && rand() < 0.02)) {
            y[c] = 0;
            l[c] = int(rand() * 15) + 5;
        }

        if (y[c] >= 0) {
            # 1. Tail Erasing
            # We calculate the position of the very last character in the tail
            # and replace it with a space to "move" the stream down.
            if (y[c] - l[c] > 0 && y[c] - l[c] <= lines) {
                printf "\033[%d;%dH ", y[c] - l[c], c;
            }

            # 2. Body Rendering (Dim Green)
            # This prints a random character at the current "head" position
            # in green (\033[32m).
            if (y[c] > 0 && y[c] <= lines) {
                r_char = substr(chars, int(rand() * len_chars) + 1, 1);
                printf "\033[%d;%dH\033[32m%s", y[c], c, r_char;
            }

            # 3. Head Rendering (Bright White)
            # The Matrix effect features a leading bright white character.
            # We print this one row ahead of the green body (\033[1;37m).
            if (y[c] + 1 > 0 && y[c] + 1 <= lines) {
                r_char_head = substr(chars, int(rand() * len_chars) + 1, 1);
                printf "\033[%d;%dH\033[1;37m%s", y[c] + 1, c, r_char_head;
            }

            y[c]++;
        } else {
            # Stream is still "falling" from above the visible area
            y[c]++;
        }
    }
    # fflush() is mandatory to prevent AWK from buffering output,
    # which would cause the animation to stutter.
    fflush();
}'

```

# scripts/generate-pass

```
#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# File Purpose
#   Provides a secure and interactive utility for generating high-entropy
#   passwords directly from the command line.
#
# Problems Solved
#   - Eliminates the use of visually ambiguous characters (e.g., 0 vs O, 1 vs l).
#   - Sources true randomness via the system entropy pool (/dev/urandom).
#   - Automates the "generate-copy-verify" workflow across different OS platforms.
#
# Features / Responsibilities
#   - Interactive Selection: Uses FZF to provide quick strength presets.
#   - Clipboard Integration: Detects and uses pbcopy, wl-copy, xclip, or clip.exe.
#   - Strength Visualization: Color-coded feedback based on character length.
#   - POSIX Compliance: Uses LC_ALL=C for consistent character set filtering.
#
# Usage Notes
#   - Run 'generate-password' for the menu or 'generate-password <length>' for immediate generation.
# ------------------------------------------------------------------------------


# ── initialization ───────────────────────────────────────────────────────────
# ----------------------------------------------------------------------------
# Environment Sandbox

# emulate -L zsh: Ensures standard Zsh behavior within this local scope.
# pipefail: Ensures that if 'tr' fails but 'head' succeeds, the error is caught.
emulate -L zsh
setopt localoptions no_xtrace pipefail


# ── input handling ─────────────────────────────────────────────────────────
local target_length="$1"

# If no length is provided, we enter the Interactive Selection mode.
if [[ -z "$target_length" ]]; then

    # Check if fzf is installed using the Zsh $+commands hash.
    if (( $+commands[fzf] )); then
        local selected
        local -a strength_presets=(
            "16      (Standard - Good for most sites)"
            "24      (Strong - Recommended for Emails/Banking)"
            "32      (Ultra - Paranoia Mode)"
            "64      (Maximum - API Keys/Secrets)"
            "CUSTOM  (Enter specific length manually)"
        )

        # --- Complex Logic: FZF Interface ---
        # We pipe the array into fzf to create a searchable TUI menu.
        selected=$(print -f "%s\n" "${strength_presets[@]}" | fzf \
            --height=20% --layout=reverse --border --info=hidden \
            --border-label='   Password Generator ' \
            --prompt=" SELECT PASSWORD STRENGTH : " \
            --color="header:blue,prompt:cyan,pointer:green"
        )

        # Exit gracefully if the user hits ESC or Ctrl+C in FZF.
        if [[ -z "$selected" ]]; then return 0; fi

        # Extract the numeric part of the selection.
        target_length=$(print "$selected" | awk '{print $1}')

        # Allow the user to type a specific integer if presets aren't enough.
        if [[ "$target_length" == "CUSTOM" ]]; then
            print
            print -P "${COLOR[CYAN]}Enter custom length:${COLOR[RESET]}"
            target_length=""
            # vared: Zsh-native variable editor for interactive input.
            vared -p "➜ " -c target_length
        fi
    else
        # Fallback for systems without FZF.
        print -P "${COLOR[CYAN]}Enter password length (Default: 16):${COLOR[RESET]}"
        vared -p "➜ " -c target_length
        target_length="${target_length:-16}"
    fi
fi


# ── validation ───────────────────────────────────────────────────────────────────────
# Strip any accidental whitespace from the input.
target_length="${target_length// /}"

# Verify that the length is a valid integer and meets minimum security requirements.
if ! [[ "$target_length" =~ ^[0-9]+$ ]] || (( target_length < 4 )); then
    print -P "${COLOR[RED]}[ERROR]${COLOR[RESET]} Invalid length: '$target_length'. Please use a number >= 4."
    return 1
fi


# ── generation engine ──────────────────────────────────────────────────────
# !!! CRITICAL: Character Set Definition
# We exclude 'I', 'l', '1', 'O', and '0' to prevent transcription errors.
local letters='A-HJ-NP-Za-kmnp-z2-9'
local symbols='!@#$%^&*()_+='
local charset="${letters}${symbols}"

local password

# ---- SAFE: Cryptographic Randomness Pipeline
# 1. LC_ALL=C: Forces 'tr' to treat input as raw bytes (crucial for /dev/urandom).
# 2. tr -dc: Deletes all characters NOT in our allowed charset.
# 3. fold -w: Wraps the infinite stream into rows of the desired length.
# 4. head -n 1: Grabs only the first row generated.
password=$(LC_ALL=C tr -dc "$charset" < /dev/urandom | fold -w "$target_length" | head -n 1)


# ── output & clipboard ─────────────────────────────────────────────────────
local copied_to_clipboard=0

# The `$=` tells Zsh to safely split the string into a command + arguments.
if [[ "$_clip" != "cat" ]]; then
    print -n "$password" | $=_clip
    copied_to_clipboard=1
fi


# ── strength report ────────────────────────────────────────────────────────
# Determine visual flavor based on the password's entropy (length).
local color="${COLOR[RED]}"
local strength_label="WEAK"

if (( target_length >= 12 ));  then color="${COLOR[YELLOW]}";  strength_label="GOOD";           fi
if (( target_length >= 20 ));  then color="${COLOR[GREEN]}";   strength_label="STRONG";         fi
if (( target_length >= 32 ));  then color="${COLOR[CYAN]}";    strength_label="INSANE";         fi
if (( target_length >= 64 ));  then color="${COLOR[MAGENTA]}"; strength_label="FREAKY";         fi
if (( target_length >= 100 )); then color="${COLOR[BLUE]}";    strength_label="ULTRA-INSTINCT"; fi

print
print -P "󱕵 ${COLOR[BOLD]}Generated Password:${COLOR[RESET]}"
print -r "   "$'\e[2;4m'"$password"$'\e[0m'
print
print -P "   Strength: $color$strength_label${COLOR[RESET]} ($target_length chars)"

if (( copied_to_clipboard )); then
    print -P "   Status:   ${COLOR[GREEN]}✔ Copied to clipboard${COLOR[RESET]}"
else
    print -P "   Status:   ${COLOR[YELLOW]}⚠ Clipboard tool not found${COLOR[RESET]}"
fi
print

```

# scripts/extract

```
#!/usr/bin/env zsh
#    ░█▀▀░█░█░▀█▀░█▀▄░█▀█░█▀▀░▀█▀
#    ░█▀▀░▄▀▄░░█░░█▀▄░█▀█░█░░░░█░
#    ░▀▀▀░▀░▀░░▀░░▀░▀░▀░▀░▀▀▀░░▀░

# ------------------------------------------------------------------------------
# File Purpose
#   Provides a universal archive extraction utility that eliminates the need
#   to remember specific flags for different compression formats.
#
# Problems Solved
#   - Standardizes the interface for tar, zip, rar, 7z, and more.
#   - Prevents accidental deletion of source files (uses -k/keep where possible).
#   - Improves UI by hiding noisy terminal output and replacing it with
#     a clean progress spinner.
#   - Handles cross-platform binary detection and dependency validation.
#
# Features / Responsibilities
#   - Multi-format support: .tar.*, .zip, .rar, .7z, .deb, .gz, etc.
#   - Smart Case Handling: Converts filenames to lowercase for extension matching.
#   - Visual Feedback: TUI-style dashboard with file metadata and duration timer.
#   - Error Logging: Captures stderr to a temporary log, displayed only on failure.
#
# Usage Notes
#   - Syntax: extract <filename>
#   - Requires: Appropriate binaries for specific formats (unzip, unrar, etc.).
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# 1. Environment Sandbox

# We use 'emulate -L zsh' to maintain local scope for options like pipefail.
emulate -L zsh
setopt localoptions no_xtrace pipefail


# ------------------------------------------------------------------------------
# 2. Input Validation

local file="$1"

# Check if an argument was provided
if [[ -z "$file" ]]; then
    print "${COLOR[RED]}[ERROR]${COLOR[RESET]} Usage: extract <archive_file>"
    return 1
fi

# Check if the file physically exists on the disk
if [[ ! -f "$file" ]]; then
    print "${COLOR[RED]}[ERROR]${COLOR[RESET]} File '${COLOR[BOLD]}$file${COLOR[RESET]}' not found."
    return 1
fi

# ------------------------------------------------------------------------------
# 3. Strategy Selection

# We define the command and specific arguments based on the file extension.
local cmd=""
local args=""
local lower_file="${file:l}" # Zsh-native lowercase conversion

case "$lower_file" in
    # TAR Variants: Modern tar auto-detects compression (gzip, bzip2, xz, zstd)
    *.tar.gz|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.txz|*.tar.zst|*.tar)
        cmd="tar"
        args="xf"
        ;;
    *.gz)
        cmd="gunzip"
        args="-k" # Keep original source file
        ;;
    *.bz2)
        cmd="bunzip2"
        args="-k"
        ;;
    *.xz)
        cmd="unxz"
        args="-k"
        ;;
    *.zip)
        cmd="unzip"
        args="-q" # Quiet mode (suppress file list)
        ;;
    *.rar)
        cmd="unrar"
        args="x -inul" # x: with full paths, -inul: Disable all messages
        ;;
    *.7z)
        cmd="7z"
        args="x -bd" # -bd: Disable progress bar (we use our spinner)
        ;;
    *.z)
        cmd="uncompress"
        args=""
        ;;
    *.deb)
        # Debian packages use 'ar' format
        if (( $+commands[ar] )); then
            cmd="ar"
            args="x"
        else
            print "${COLOR[RED]}[ERROR]${COLOR[RESET]} 'ar' command needed for .deb extraction."
            return 1
        fi
        ;;
    *)
        print "${COLOR[RED]}[ERROR]${COLOR[RESET]} Unsupported format: ${file:e}"
        return 1
        ;;
esac

# ------------------------------------------------------------------------------
# 4. Dependency Validation

# Check the Zsh 'commands' hash to verify the binary is in the $PATH
if (( ! $+commands[$cmd] )); then
    print "${COLOR[RED]}[ERROR]${COLOR[RESET]} Command '${COLOR[BOLD]}$cmd${COLOR[RESET]}' is required but not installed."
    print "        Please install it (e.g., brew install $cmd / sudo apt install $cmd)"
    return 1
fi

# ------------------------------------------------------------------------------
# 5. Execution Dashboard

# Calculate file size for the UI header
local size=$(du -h "$file" | cut -f1)

# Grab the raw values
local val_file="${file:t}"
local val_size="$size"
local val_cmd="$cmd"

# Smart Truncation:
# Inner width is 38. Prefix ("  File:   ") is 10. Max value length is 28.
if (( ${#val_file} > 28 )); then
    val_file="${val_file:0:25}..."
fi

# Calculate required padding spaces
local pad_file=$(( 38 - 10 - ${#val_file} ))
local pad_size=$(( 38 - 10 - ${#val_size} ))
local pad_cmd=$(( 38 - 10 - ${#val_cmd} ))

# Generate the exact whitespace needed
local space_file="" space_size="" space_cmd=""
(( pad_file > 0 )) && printf -v space_file "%*s" $pad_file ""
(( pad_size > 0 )) && printf -v space_size "%*s" $pad_size ""
(( pad_cmd > 0 ))  && printf -v space_cmd "%*s" $pad_cmd ""

# Print the perfectly aligned box
print "${COLOR[BLUE]}╭──────────────────────────────────────╮${COLOR[RESET]}"
print "${COLOR[BLUE]}│        📦  ARCHIVE EXTRACTOR         │${COLOR[RESET]}"
print "${COLOR[BLUE]}├──────────────────────────────────────┤${COLOR[RESET]}"
print "${COLOR[BLUE]}│${COLOR[RESET]}  File:   ${COLOR[WHITE]}${val_file}${COLOR[RESET]}${space_file}${COLOR[BLUE]}│${COLOR[RESET]}"
print "${COLOR[BLUE]}│${COLOR[RESET]}  Size:   ${COLOR[WHITE]}${val_size}${COLOR[RESET]}${space_size}${COLOR[BLUE]}│${COLOR[RESET]}"
print "${COLOR[BLUE]}│${COLOR[RESET]}  Method: ${COLOR[YELLOW]}${val_cmd}${COLOR[RESET]}${space_cmd}${COLOR[BLUE]}│${COLOR[RESET]}"
print "${COLOR[BLUE]}╰──────────────────────────────────────╯${COLOR[RESET]}"

print -n "   ${COLOR[BLUE]}::${COLOR[RESET]} Extracting... "

# ------------------------------------------------------------------------------
# 6. Background Execution & Async Spinner

# We record start time to calculate total extraction duration.
local start_time=$EPOCHREALTIME

# Create a temporary log file to capture potential error messages.
local log_file=$(mktemp)

# !!! CRITICAL: Subprocess Management
# We execute the extraction in the background to keep the terminal responsive
# and allow the spinner loop to run in the foreground.
if [[ "$cmd" == "tar" ]]; then
    tar "$args" "$file" >"$log_file" 2>&1 &
elif [[ "$cmd" == "unrar" ]]; then
    unrar x -inul "$file" >"$log_file" 2>&1 &
elif [[ "$cmd" == "unzip" ]]; then
    unzip -q "$file" >"$log_file" 2>&1 &
elif [[ "$cmd" == "7z" ]]; then
    7z x -bd "$file" >"$log_file" 2>&1 &
else
    $cmd $args "$file" >"$log_file" 2>&1 &
fi

local pid=$! # Capture the Process ID of the background extraction
local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
local i=0

# Hide the cursor during the visual spinner phase
tput civis 2>/dev/null

# ---- SAFE: Loop while the extraction PID is still active
while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) % 10 ))
    print -f "\b${COLOR[BLUE]}${spin:$i:1}${COLOR[RESET]}"
    sleep 0.1
done

# Restore the cursor immediately after background task finishes
tput cnorm 2>/dev/null

# Synchronize and fetch the exit status of the background command
wait $pid
local exit_code=$?

# Math: Calculate total duration
local end_time=$EPOCHREALTIME
local duration=$(( end_time - start_time ))
local duration_fmt=$(print -f "%.2f" $duration)

# ------------------------------------------------------------------------------
# 7. Final Reporting

print -f "\b" # Clean up the last spinner character

if (( exit_code == 0 )); then
    print "${COLOR[GREEN]}✔${COLOR[RESET]} Done in ${duration_fmt}s"
    rm -f "$log_file"
else
    # In case of failure, we display the stored error log to the user.
    print "${COLOR[RED]}✘${COLOR[RESET]} Failed."
    print
    print "${COLOR[YELLOW]}--- Error Log ---${COLOR[RESET]}"
    cat "$log_file"
    rm -f "$log_file"
    return $exit_code
fi

```

# scripts/countdown

```
#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# File Purpose
#   Provides a high-precision, interactive terminal countdown timer.
#
# Problems Solved
#   - Eliminates terminal flickering during rapid UI updates by utilizing
#     terminal "Home" cursor positioning instead of full screen clears.
#   - Provides sub-second precision for timing using the zsh/datetime module.
#   - Handles terminal state management to provide a clean TUI experience.
#
# Features / Responsibilities
#   - Interactive controls (Space: Pause/Resume, Q: Quit).
#   - Dynamic progress bar using native Zsh string padding (no external forks).
#   - Desktop notifications for macOS and audible system bells.
#
# Usage Notes
#   - Syntax: countdown 1h 30m 10s
#   - Requires: zsh/datetime and zsh/mathfunc modules.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Environment Sandbox

# We use 'emulate -L zsh' to ensure the function runs with standard Zsh behavior.
emulate -L zsh

# Disable tracing to keep the TUI clean and prevent debug output interference.
setopt localoptions no_xtrace no_verbose

# Clear any active traps that might interfere with timing logic.
trap - DEBUG
trap - ZERR

# Load Zsh modules for high-resolution time ($EPOCHREALTIME)
# and mathematical functions (int, float).
zmodload zsh/datetime
zmodload zsh/mathfunc


# ── argument parsing ───────────────────────────────────────────────────────

# Strip the function name if it was passed as the first argument by a wrapper.
if [[ "$1" == "countdown" ]]; then shift; fi

local target_seconds=0

# ------------------------------------------------------------------------------
# Complex Logic: Time Parsing
# This loop processes human-readable strings (e.g., 1h, 5m, 10s) and converts
# them into a single integer representing the total number of seconds.
# It uses Zsh's parameter expansion ${arg%h} to strip the suffix before math.
if [[ $# -eq 0 ]]; then
    target_seconds=60
else
    for arg in "$@"; do
        case "$arg" in
            [0-9]*h) target_seconds=$((target_seconds + ${arg%h} * 3600)) ;;
            [0-9]*m) target_seconds=$((target_seconds + ${arg%m} * 60)) ;;
            [0-9]*s) target_seconds=$((target_seconds + ${arg%s})) ;;
            [0-9]##) target_seconds=$((target_seconds + arg)) ;;
            *)
                print "${COLOR[RED]}[ERROR]${COLOR[RESET]} Unknown format '${COLOR[BOLD]}$arg${COLOR[RESET]}'. Valid: 1h, 30m, 90."
                return 1
                ;;
        esac
    done
fi

if (( target_seconds <= 0 )); then
    print "${COLOR[RED]}[ERROR]${COLOR[RESET]} Time must be > 0."
    return 1
fi


# ── terminal setup ─────────────────────────────────────────────────────────

# !!! CRITICAL: UI state management
# Hide cursor and stop the terminal from echoing user keystrokes (-echo).
# We use tput civis for broader terminal compatibility.
print -f "\e[?25l"
stty -echo
tput civis 2>/dev/null

# ---- SAFE: Restore terminal state on any exit condition
trap 'stty echo; print -f "\e[?25h"; tput cnorm 2>/dev/null; return' INT TERM EXIT

# Initialize timing variables using $EPOCHREALTIME (float) for accuracy.
local start_time=$EPOCHREALTIME
local pause_time=0
local accumulated_pause=0
local is_paused=0
clear


# ── main execution loop ────────────────────────────────────────────────────

local key=""
while true; do
    # ------------------------------------------------------------------------------
    # Complex Logic: Dynamic Elapsed Time
    # To support pause/resume functionality without time-drift, we track the
    # 'accumulated_pause'. When paused, we fix the 'pause_time'.
    # When resumed, we add the duration of the pause to our cumulative offset.
    local current_time=$EPOCHREALTIME
    local elapsed=0

    if (( is_paused )); then
        elapsed=$((pause_time - start_time - accumulated_pause))
    else
        elapsed=$((current_time - start_time - accumulated_pause))
    fi

    local remaining=$((target_seconds - elapsed))

    # Prevent the timer from displaying negative values if the loop overshoots.
    if (( remaining < 0 )); then remaining=0; fi

    # Breakdown seconds into human-readable components using mathfunc.
    local h=$((int(remaining / 3600)))
    local m=$((int((remaining % 3600) / 60)))
    local s=$((int(remaining % 60)))
    local ms=$((int((remaining - int(remaining)) * 100)))


    # ------------------------------------------------------------------------------
    # Complex Logic: Progress Bar
    # We calculate 'pct' as a ratio. To draw the bar, we generate strings of
    # specific characters using Zsh's unique (l:size::char:) padding expansion.
    # This is high-performance because it avoids for-loops or external calls.
    local width=30
    local pct=$((elapsed * 1.0 / target_seconds))
    if (( pct > 1 )); then pct=1; fi

    local fill_size=$((int((1.0 - pct) * width)))

    # ---- SAFE: Clamp values to bar bounds to prevent expansion errors
    if (( fill_size < 0 ));     then fill_size=0; fi
    if (( fill_size > width )); then fill_size=width; fi

    local empty_size=$((width - fill_size))

    # ${(l:fill_size::█:):-} generates a string of '█' of length 'fill_size'
    local bar_fill="${(l:fill_size::█:):-}"
    local bar_empty="${(l:empty_size::░:):-}"


    # ------------------------------------------------------------------------------
    # UI Rendering

    # \e[H moves the cursor to the top-left (Home).
    # By overwriting the same lines instead of clearing, we eliminate flicker.
    print -f "\e[H"

    local status_color="${COLOR[GREEN]}"
    local status_text="RUNNING "

    if (( is_paused )); then
        status_color="${COLOR[YELLOW]}"
        status_text="PAUSED  "
    elif (( remaining < 10 )); then
        status_color="${COLOR[RED]}"
        status_text="CRITICAL"
    fi

    # Draw the TUI Container.
    print "${COLOR[BLUE]}╭──────────────────────────────────────╮${COLOR[RESET]}"
    print "${COLOR[BLUE]}│             ${status_color}  $status_text              ${COLOR[BLUE]}│${COLOR[RESET]}"

    # Format the time numbers into fixed-width slots for stability.
    print -f "${COLOR[BLUE]}│             ${COLOR[B_WHITE]}%02d:%02d:%02d${COLOR[GREY]}.%02d              ${COLOR[BLUE]}│${COLOR[RESET]}\n" $h $m $s $ms

    print "${COLOR[BLUE]}│    ${status_color}${bar_fill}${COLOR[GREY]}${bar_empty}${COLOR[RESET]}    ${COLOR[BLUE]}│${COLOR[RESET]}"
    print "${COLOR[BLUE]}├──────────────────────────────────────┤${COLOR[RESET]}"
    print "${COLOR[BLUE]}│       ${COLOR[GREY]}[SPACE] Pause   [Q] Quit       ${COLOR[BLUE]}│${COLOR[RESET]}"
    print "${COLOR[BLUE]}╰──────────────────────────────────────╯${COLOR[RESET]}"


    # ── interaction / feedback ───────────────────────────────────────────

    if (( remaining <= 0 )); then
        print -f "\a" # System bell
        break
    fi

    # ------------------------------------------------------------------------------
    # Complex Logic: Input Handling
    # read -sk 1: Reads 1 char silently.
    # -t 0.05: Blocks for only 50ms, allowing the clock to update 20 times per second.
    key=""
    read -sk 1 -t 0.05 key 2>/dev/null

    case "$key" in
        [qQ])
            print "\n${COLOR[YELLOW]}:: Timer cancelled.${COLOR[RESET]}"
            return
            ;;
        " ")
            if (( is_paused )); then
                is_paused=0
                accumulated_pause=$((accumulated_pause + (EPOCHREALTIME - pause_time)))
            else
                is_paused=1
                pause_time=$EPOCHREALTIME
            fi
            ;;
    esac
done


# ── finalization ───────────────────────────────────────────────────────────

clear
print "${COLOR[GREEN]}"
print "  ╭──────────────────────╮"
print "  │      TIME IS UP!     │"
print "  ╰──────────────────────╯"
print "${COLOR[RESET]}"

notify_user "Countdown" "Timer Finished"

```

# conf.d/hooks.zsh

```
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

```

# conf.d/aliases.zsh

```
alias calc="gcalccmd"
alias c="clear"
alias cls="clear"
alias clock="tty-clock"
alias ls="eza --icons"
alias tree="ls --tree"
alias v="nvim"

alias src='source'
alias inv='nvim $(fzf --tmux top,60%  -m --preview="bat --color=always {}")'
alias killfzf='kill -9 $(ps aux | fzf-tmux --height 60% --multi | awk "{print \$2}")'
alias tmux-del='tmux list-sessions -F "#{session_name}" | grep -v "^default$"| xargs -I {} tmux kill-session -t {}'
alias i='paru -S'

alias ff="fastfetch"
alias pf="pfetch"
alias nf="nitch"  

alias poff="systemctl poweroff --no-wall"
alias rbt="systemctl reboot --no-wall"
alias logout="loginctl terminate-session $(loginctl | rg $(whoami) | awk '{print $1}')"
alias sudo="sudo-rs"
alias su="su-rs"
alias visudo="visudo-rs"
alias new="touch"

alias note="yazi ~/Obsidian/"

alias daily="nvim ~/Obsidian/Life/game/Quests/Daily/$(date +%Y-%m-%d).md"

```

# conf.d/syntax.zsh

```
if [[ ! -f "$HOME/.config/fsh/catppuccin-mocha.ini "]]; then
    fast-theme XDG:catppuccin-mocha
fi

# Catppuccin Mocha Theme (for zsh-syntax-highlighting)
#
# Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
#
## General
### Diffs
### Markup
## Classes
## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#585b70'
## Constants
## Entitites
## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fab387,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#cba6f7'
## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#a6e3a1'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#f38ba8'
## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#f9e2af'
## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#cdd6f4'
## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[path]='fg=#cdd6f4,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#f38ba8,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#cdd6f4,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#f38ba8,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#cba6f7'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[default]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#cdd6f4'

```

# conf.d/env.zsh

```
#!/usr/bin/env zsh
paths=(
    "/usr/local/opt/openjdk/bin"
    "$HOME/.cargo/bin"
    "$HOME/.spicetify"
    "$HOME/.local/bin"
    "$HOME/.config/zsh/scripts"
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

export LANG=en_US.utf8
export LC_ALL=en_US.utf8

```

# conf.d/plugins.zsh

```
#!/bin/env zsh

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

```

# conf.d/options.zsh

```
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#B4BEFE,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#B4BEFE,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#B4BEFE,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4 \
--border=rounded \
--margin=3% \
--padding=1 \
--height=60% \
--min-height=15 \
--layout=reverse \
--info=inline-right \
--separator='┄' \
--scrollbar='▌' \
--prompt='❯ ' \
--marker='✓' \
--pointer='▶' \
--preview-window='right:60%:rounded' \
--preview='bat --color=always --style=full --line-range=:500 {} 2>/dev/null || \
           exa --color=always --icons --tree --level=2 {} 2>/dev/null || \
           head -n 500 {} 2>/dev/null || \
           echo \"Cannot preview: {} is binary or unsupported\"' \
"

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

```

# conf.d/keybinds.zsh

```
bindkey -r '\ec'
bindkey '^[f' fzf-cd-widget
bindkey '^[^?' backward-kill-word
bindkey '^[[3~' delete-char
bindkey '^[^[[3~' kill-word
bindkey '^[d' kill-word


```

# conf.d/functions.zsh

```
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

function fv() {
  local file
  file=$(fzf)
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
} 

```

# conf.d/etc.zsh

```
#!/usr/bin/env zsh
# ========== POST-PLUGIN SETUP ========== #
autoload -Uz compinit
compinit -C

zstyle ':completion:*' list-colors 'di=34' 'ex=32' 'fi=0' 'ln=36'
zstyle ':completion:*' format '%B%F{34}%d%f%b'
zstyle ':completion:*:descriptions' format '%B%F{34}-- %d --%f%b'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

zstyle ':completion:*' menu select

bindkey -v

bindkey -M vicmd 'h' vi-backward-char
bindkey -M vicmd 'l' vi-forward-char
bindkey -M vicmd 'j' vi-down-line-or-history
bindkey -M vicmd 'k' vi-up-line-or-history

```
