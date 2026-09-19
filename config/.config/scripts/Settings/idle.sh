#!/bin/bash

# Check if hypridle is already running
if pgrep -x "hypridle" > /dev/null; then
    # Kill hypridle if its running (switch to normal mode)
    killall -9 hypridle 
    notify-send "Idle" "Disabled" -u "low"
else
    # Start hypridle sunset if its not running (switch to night mode)
    hypridle &
    notify-send "Idle" "Enabled" -u "low"
fi


