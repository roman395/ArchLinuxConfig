#!/bin/bash

# Цвета через tput (без Unicode)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Директория с конфигами
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Массив конфигов
declare -A CONFIG_MAP=(
    [".zshrc"]="$HOME/.zshrc"
    ["hyprland.conf"]="$HOME/.config/hypr/hyprland.conf"
    ["kitty.conf"]="$HOME/.config/kitty/kitty.conf"
    ["cava"]="$HOME/.config/cava/config"

)

echo "${BOLD}${BLUE}=== Установка конфигов через симлинки ===${RESET}"

for file in "${!CONFIG_MAP[@]}"; do
    target="${CONFIG_MAP[$file]}"
    source_file="$CONFIG_DIR/$file"
    
    echo "${BOLD}${BLUE}[Обработка]${RESET} ${BOLD}$file${RESET} -> ${BOLD}$target${RESET}"

    # Проверка исходного файла
    if [[ ! -f "$source_file" ]]; then
        echo "  ${RED}[ОШИБКА]${RESET} Исходный файл ${BOLD}$file${RESET} не найден!"
        continue
    fi

    # Обработка существующего целевого файла
    if [[ -e "$target" ]]; then
        if [[ -L "$target" ]]; then
            current_link=$(readlink -f "$target")
            if [[ "$current_link" == "$source_file" ]]; then
                echo "  ${GREEN}[ПРОПУСК]${RESET} Симлинк уже корректный"
                continue
            else
                echo "  ${YELLOW}[ВНИМАНИЕ]${RESET} Удаляю старый симлинк (ведёт на ${current_link})"
                rm -v "$target"
            fi
        else
            echo "  ${YELLOW}[БЭКАП]${RESET} Создаю бэкап: ${BOLD}$target.bak${RESET}"
            mv -v "$target" "$target.bak"
        fi
    fi

    # Создание папки
    mkdir -p "$(dirname "$target")"

    # Создание симлинка
    if ln -sv "$source_file" "$target"; then
        echo "  ${GREEN}[УСПЕХ]${RESET} Симлинк создан"
    else
        echo "  ${RED}[ОШИБКА]${RESET} Не удалось создать симлинк!"
    fi
    
    echo "${BLUE}------------------------------------${RESET}"
done

echo "${BOLD}${BLUE}=== Готово! ===${RESET}"