#!/bin/bash

# Check if hyprsunset is already running
if pgrep -x "hyprsunset" > /dev/null; then
    # Kill hyprsunset if its running (switch to normal mode)
    killall -9 hyprsunset
    notify-send "Night Light" "Off" -u "low"
else
    # Start hyprsunset if its not running (switch to night mode)
    hyprsunset -t 5500 &
    notify-send "Night Light" "On" -u "low"
fi

