#!/bin/bash

# Директория, где лежат конфиги в репозитории
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Массив соответствий: "файл_в_репозитории -> куда_положить_в_системе"
declare -A CONFIG_MAP=(
    [".zshrc"]="$HOME/.zshrc"
    ["hyprland.conf"]="$HOME/.config/hypr/hyprland.conf"
    ["kitty.conf"]="$HOME/.config/kitty/kitty.conf"

)

echo "🔹 Установка конфигов через симлинки..."

# Создаем симлинки
for file in "${!CONFIG_MAP[@]}"; do
    target="${CONFIG_MAP[$file]}"
    echo "🔸 Обрабатываю: $file → $target"

    # Проверяем, существует ли исходный файл
    if [[ ! -f "$CONFIG_DIR/$file" ]]; then
        echo "⚠ Ошибка: файл $file не найден в репозитории!"
        continue
    fi

    # Если целевой файл уже существует, делаем бэкап
    if [[ -f "$target" || -L "$target" ]]; then
        echo "🔹 Файл $target уже существует, создаю бэкап..."
        mv "$target" "$target.bak"
    fi

    # Создаем папку, если её нет
    mkdir -p "$(dirname "$target")"

    # Создаем симлинк
    ln -s "$CONFIG_DIR/$file" "$target"
    echo "✅ Симлинк создан: $file → $target"
done

echo "✨ Готово! Конфиги установлены."
