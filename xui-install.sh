#!/bin/bash

# Создаем папку в корневом каталоге
echo "Создание папки /vpnserver-xui..."
mkdir /vpnserver-xui

# Переходим в созданную папку
echo "Переход в папку /vpnserver-xui..."
cd /vpnserver-xui

# Клонируем репозиторий
echo "Клонирование репозитория..."
git clone https://github.com/Solovey-Tech/Private-Pattern.git .

# Проверяем, успешно ли прошло клонирование
if [ $? -eq 0 ]; then
    echo "Репозиторий успешно склонирован."
else
    echo "Ошибка при клонировании репозитория."
    exit 1
fi

# Запускаем vpn_installer.py
echo "Запуск vpn_installer.py..."
python3 vpn_installer.py

# Проверяем, успешно ли прошел запуск скрипта
if [ $? -eq 0 ]; then
    echo "vpn_installer.py успешно запущен."
else
    echo "Ошибка при запуске vpn_installer.py."
    exit 1
fi