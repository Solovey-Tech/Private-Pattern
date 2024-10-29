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

# Проверяем наличие папки qrcodeserver в каталоге /root и переносим ее в корневой каталог /
if [ -d "/root/qrcodeserver" ]; then
    echo "Папка qrcodeserver найдена в /root. Переносим ее в корневой каталог /..."
    sudo mv /root/qrcodeserver /
fi

# Устанавливаем python3-pip и mc bmon  и  netperf
echo "Установка python3-pip и mc..."
sudo apt-get update
sudo apt-get install -y python3-pip mc
sudo apt-get install -y bmon
sudo apt-get install -y netperf
sudo apt-get install -y speedtest-cli


# Запускаем vpn_installer.py
echo "Запуск vpn_installer.py..."
python3 vpn_installer.py

# Проверяем, успешно ли прошел запуск скрипта
if [ $? -eq 0 ]; then
    echo "Обновления прошли успешно"
else
    echo "Ошибка при запуске vpn_installer.py."
    exit 1
fi

# Запускаем avtoconfig.py как демон с использованием systemctl
echo "Создание службы для avtoconfig.py..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/avtoconfig.service
[Unit]
Description=avtoconfig.py Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 /qrcodeserver/avtoconfig.py
WorkingDirectory=/qrcodeserver
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

echo "Перезагрузка демонов..."
sudo systemctl daemon-reload

echo "Запуск службы avtoconfig.py..."
sudo systemctl start avtoconfig.service

echo "Включение службы avtoconfig.py для запуска при загрузке системы..."
sudo systemctl enable avtoconfig.service

echo "avtoconfig.py запущен как демон."

# Копируем скрипт api.py в папку /apipservicevpn/
echo "Копирование скрипта api.py в папку /apipservicevpn/..."
sudo mkdir -p /apipservicevpn
sudo cp /qrcodeserver/api.py /apipservicevpn/

# Запускаем api.py как демон с использованием systemctl
echo "Создание службы для api.py..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/apipservicevpn.service
[Unit]
Description=api.py Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 /apipservicevpn/api.py
WorkingDirectory=/apipservicevpn
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

echo "Перезагрузка демонов..."
sudo systemctl daemon-reload

echo "Запуск службы api.py..."
sudo systemctl start apipservicevpn.service

echo "Включение службы api.py для запуска при загрузке системы..."
sudo systemctl enable apipservicevpn.service

echo "api.py запущен как демон.."
echo " Я все!!!"