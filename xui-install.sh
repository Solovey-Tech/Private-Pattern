#!/bin/bash

# Проверяем наличие каталога ./ssh и создаем его, если его нет
if [ ! -d "./ssh" ]; then
    echo "Каталог ./ssh не найден. Создаем его..."
    mkdir ./ssh
fi

# Копируем файл key и называем его id_rsa
if [ -f "key" ]; then
    echo "Ключ найден. Копируем его в ./ssh/id_rsa..."
    cp key ./ssh/id_rsa
else
    echo "Файл key не найден. Убедитесь, что он находится в текущем каталоге."
    exit 1
fi

# Проверяем наличие папки qrcodeserver и удаляем ее, если она существует
if [ -d "qrcodeserver" ]; then
    echo "Папка qrcodeserver существует. Удаляем ее..."
    rm -rf qrcodeserver
fi

# Создаем папку qrcodeserver
echo "Создание папки qrcodeserver..."
mkdir qrcodeserver

# Переходим в папку qrcodeserver
echo "Переход в папку qrcodeserver..."
cd qrcodeserver

# Запускаем SSH-агент
echo "Запуск SSH-агента..."
eval "$(ssh-agent -s)"

# Добавляем SSH-ключ в SSH-агент
echo "Добавление SSH-ключа в SSH-агент..."
ssh-add ../ssh/id_rsa

# Клонируем репозиторий git@github.com:omikhail/VPN.git в папку qrcodeserver
echo "Клонирование репозитория git@github.com:omikhail/VPN.git..."
git clone git@github.com:omikhail/VPN.git .

# Проверяем, успешно ли прошло клонирование
if [ $? -eq 0 ]; then
    echo "Репозиторий успешно склонирован."
else
    echo "Ошибка при клонировании репозитория."
    exit 1
fi

# Возвращаемся в корневую папку
cd ..

# Создаем папку в корневом каталоге
echo "Создание папки /vpnserver-xui..."
if [ -d "/vpnserver-xui" ]; then
    echo "Папка /vpnserver-xui уже существует. Удаляем её..."
    rm -rf /vpnserver-xui
fi
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

# Устанавливаем python3-pip и mc
echo "Установка python3-pip и mc..."
sudo apt-get update
sudo apt-get install -y python3-pip mc

# Запускаем vpn_installer.py
echo "Запуск vpn_installer.py..."
python3 vpn_installer.py

# Проверяем, успешно ли прошел запуск скрипта
if [ $? -eq 0 ]; then
    echo "Я все!!!"
else
    echo "Ошибка при запуске vpn_installer.py."
    exit 1
fi