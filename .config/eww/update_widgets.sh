# ~/.config/eww/scripts/update_widgets.sh
#!/bin/bash

# Этот скрипт будет обновлять данные для виджетов
while true; do
  # Обновление информации о батарее
  battery_info=$(acpi -b | awk '{print $4}' | tr -d ',%')
  battery_status=$(acpi -b | awk '{print $3}' | tr -d ',')
  
  # Обновление громкости
  volume=$(pamixer --get-volume)
  volume_muted=$(pamixer --get-mute)
  
  # Обновление времени
  time=$(date +"%H:%M")
  date=$(date +"%d %B %Y")
  
  # Отправка данных в Eww
  eww update battery_text="$battery_info%"
  eww update battery_tooltip="Battery: $battery_info% ($battery_status)"
  eww update volume_icon="$([ $volume_muted = "true" ] && echo "ΎΑο " || echo "ΎΑρ ")"
  eww update volume_tooltip="Volume: $volume%"
  eww update clock_text="ΎΑΩ $time"
  eww update clock_tooltip="ΎΒ│ $date"
  
  sleep 5
done
