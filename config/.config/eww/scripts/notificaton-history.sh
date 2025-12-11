#!/bin/bash

get_dunst_history() {
    if command -v dunstctl &> /dev/null; then
        # Правильный jq запрос для истории dunst
        dunstctl history | jq -r '.data[0].history[] | [.appname.data, .summary.data, .body.data] | @tsv' 2>/dev/null | \
        while IFS=$'\t' read -r app summary body; do
            if [[ -n "$summary" || -n "$body" ]]; then
                echo "(box :class 'notification-item' :orientation 'horizontal'"
                echo "  (box :class 'notification-icon' \"\")"
                echo "  (box :class 'notification-content' :orientation 'vertical'"
                echo "    (label :class 'notification-app' \"$app\")"
                echo "    (label :class 'notification-summary' \"$summary\")"
                echo "    (label :class 'notification-body' :wrap true \"$body\")))"
            fi
        done
    else
        echo "(label :class 'error' \"dunstctl not available\")"
    fi
}

get_dunst_history
