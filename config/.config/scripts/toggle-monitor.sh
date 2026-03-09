#!/bin/bash
# Проверяем состояние монитора (примерный способ)
if [[ $(hyprctl monitors | grep -c "DPMS: On") -gt 0 ]]; then
    hyprctl dispatch dpms off
else
    hyprctl dispatch dpms on
fi
