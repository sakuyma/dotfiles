#!/bin/bash
# check-nvidia.sh - Проверка установки драйверов NVIDIA

echo "=== Проверка установки драйверов NVIDIA ==="
echo ""

# 1. Проверка загруженных модулей
echo "1. Загруженные модули NVIDIA:"
lsmod | grep nvidia
echo ""

# 2. Проверка версии драйвера
echo "2. Версия драйвера NVIDIA:"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=driver_version --format=csv,noheader
else
    echo "nvidia-smi не найден"
fi
echo ""

# 3. Проверка конфигурации Xorg
echo "3. Файлы конфигурации Xorg:"
ls /etc/X11/xorg.conf.d/*nvidia* 2>/dev/null || echo "Файлы конфигурации не найдены"
echo ""

# 4. Проверка mkinitcpio
echo "4. Модули в mkinitcpio.conf:"
grep "^MODULES=" /etc/mkinitcpio.conf
echo ""

# 5. Проверка параметров ядра
echo "5. Параметры ядра GRUB:"
grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub
echo ""

# 6. Тест OpenGL
echo "6. Информация OpenGL:"
if command -v glxinfo &> /dev/null; then
    glxinfo | grep "OpenGL vendor\|OpenGL renderer"
else
    echo "glxinfo не установлен"
fi
echo ""

echo "=== Проверка завершена ==="
