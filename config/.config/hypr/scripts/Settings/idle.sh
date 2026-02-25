#!/bin/bash

# Check if hypridle is already running
if pgrep -x "hypridle" > /dev/null; then
    # Kill hypridle if its running (switch to normal mode)
    killall -9 hypridle 
    notify-send "Idling" "Off" -u "low"
else
    # Start hypridle sunset if its not running (switch to night mode)
    hypridle &
    notify-send "Idling" "On" -u "low"
fi


