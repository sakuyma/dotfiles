#!/bin/bash

echo -e "\0message\x1f📊 Dashboard"

# Левая колонка - Календарь
echo -e "📅 Календарь\0nonselectable\x1ftrue"
cal --color=never | while read line; do
    echo "$line"
done

echo -e "\0new-column\x1ftrue"

# Правая колонка - Система
echo -e "🖥️ Система\0nonselectable\x1ftrue"
echo "CPU: $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"
echo "RAM: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $4 " free"}')"
echo "Time: $(date '+%H:%M')"
echo "Date: $(date '+%d.%m.%Y')"
