# ~/.config/eww/launch.sh
#!/bin/bash

# Запуск Eww bar
eww daemon
sleep 1
eww open bar

# Запуск скрипта обновления виджетов
~/.config/eww/scripts/update_widgets.sh &
