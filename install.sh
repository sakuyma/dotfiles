#!/bin/bash
configs() {
    cd dotfiles
    mkdir -p "/home/user/"
    echo "Копирую конфиги..."
    cp -rv ../* "/home/user/"
}
paru_install() {
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

}
setup_nvidia_mkinitcpio() {
    # Проверка прав
    if [[ $EUID -ne 0 ]]; then
        echo "❌ Ошибка: Запустите с sudo: sudo bash -c '$(declare -f setup_nvidia_mkinitcpio); setup_nvidia_mkinitcpio'"
        return 1
    fi

    local config_file="/etc/mkinitcpio.conf"
    local modules=("i915" "nvidia" "nvidia_modeset" "nvidia_drm")
    local backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"

    echo "🎮 Настройка модулей NVIDIA в mkinitcpio"
    echo "========================================"

    # Создаем резервную копию
    cp "$config_file" "$backup_file"
    echo "✓ Создана резервная копия: $backup_file"

    # Получаем текущие модули
    local current_line=$(grep "^MODULES=" "$config_file")
    
    if [[ -z "$current_line" ]]; then
        echo "❌ Не найдена строка MODULES в конфиге"
        return 1
    fi

    local current_modules=$(echo "$current_line" | sed -n 's/MODULES=(\(.*\))/\1/p')
    local new_modules="$current_modules"

    # Добавляем отсутствующие модули
    echo "🔧 Добавляю модули..."
    for module in "${modules[@]}"; do
        if [[ ! " $new_modules " =~ " $module " ]]; then
            [[ -n "$new_modules" ]] && new_modules="$new_modules $module" || new_modules="$module"
            echo "  ✓ Добавлен: $module"
        else
            echo "  ⚠ Уже есть: $module"
        fi
    done

    # Обновляем конфиг
    sed -i "s/^MODULES=.*/MODULES=($new_modules)/" "$config_file"
    echo "✅ Конфиг обновлен: MODULES=($new_modules)"

    # Пересобираем initramfs
    echo "🔄 Пересобираю initramfs..."
    if mkinitcpio -P; then
        echo "✅ Initramfs успешно пересобран"
    else
        echo "❌ Ошибка при пересборке initramfs"
        return 1
    fi

    echo "========================================"
    echo "🎉 Настройка завершена! Перезагрузите систему."
    return 0
}
setup_grub_config() {
    # Проверка прав
    if [[ $EUID -ne 0 ]]; then
        echo "❌ Ошибка: Запустите с sudo: sudo bash -c '$(declare -f setup_grub_config); setup_grub_config'"
        return 1
    fi

    local grub_file="/etc/default/grub"
    local backup_file="${grub_file}.backup.$(date +%Y%m%d_%H%M%S)"

    echo "🎮 Настройка параметров GRUB"
    echo "========================================"

    # Создаем резервную копию
    cp "$grub_file" "$backup_file"
    echo "✓ Создана резервная копия: $backup_file"

    # Параметры для настройки
    declare -A grub_params=(
        ["GRUB_TIMEOUT"]="0"
        ["GRUB_CMDLINE_LINUX_DEFAULT"]="loglevel=0 quiet rd.udev.log_priority=0 vt.global_cursor_default=0 systemd.show_status=auto splash mitigations=off"
    )

    # Редактируем каждый параметр
    for param in "${!grub_params[@]}"; do
        local value="${grub_params[$param]}"
        
        # Если параметр уже существует - заменяем
        if grep -q "^${param}=" "$grub_file"; then
            sed -i "s|^${param}=.*|${param}=\"${value}\"|" "$grub_file"
            echo "✓ Обновлен: $param=\"$value\""
        else
            # Если нет - добавляем в конец файла
            echo "${param}=\"${value}\"" >> "$grub_file"
            echo "✓ Добавлен: $param=\"$value\""
        fi
    done

    # Обновляем GRUB
    echo "🔄 Обновляю конфигурацию GRUB..."
    if command -v update-grub &> /dev/null; then
        update-grub
    elif command -v grub-mkconfig &> /dev/null; then
        grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo "❌ Не найдена команда для обновления GRUB"
        return 1
    fi

    echo "✅ GRUB успешно обновлен"
    echo "========================================"
    echo "🎉 Настройка GRUB завершена!"
    return 0
}
remove_echo_from_grub() {
    # Проверка прав
    if [[ $EUID -ne 0 ]]; then
        echo "❌ Ошибка: Запустите с sudo: sudo bash -c '$(declare -f remove_echo_from_grub); remove_echo_from_grub'"
        return 1
    fi

    local grub_cfg="/boot/grub/grub.cfg"
    local backup_file="${grub_cfg}.backup.$(date +%Y%m%d_%H%M%S)"

    echo "🎮 Удаляю строки с echo из grub.cfg"
    echo "========================================"

    # Проверяем существование файла
    if [[ ! -f "$grub_cfg" ]]; then
        echo "❌ Файл $grub_cfg не найден!"
        return 1
    fi

    # Создаем резервную копию
    cp "$grub_cfg" "$backup_file"
    echo "✓ Создана резервная копия: $backup_file"

    # Подсчитываем сколько строк будет удалено
    local echo_count=$(grep -c "echo" "$grub_cfg")
    echo "✓ Найдено строк с echo: $echo_count"

    # Удаляем строки с echo
    if [[ $echo_count -gt 0 ]]; then
        sed -i '/echo/d' "$grub_cfg"
        echo "✓ Удалено $echo_count строк с echo"
    else
        echo "⚠ Строк с echo не найдено"
    fi

    echo "✅ Готово! Файл обновлен: $grub_cfg"
    return 0
}
main() {
    configs
    paru_install
    setup_grub_config
    setup_nvidia_mkinitcpio
    sudo paru -Syu  < /home/user/dotfiles/packages
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    configs
}
