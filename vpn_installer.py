# vpn_installer/vpn_installer/vpn_installer.py
import subprocess
import os
import config  # Импортируем файл конфигурации

def set_hostname(hostname):
    """Устанавливаем имя хоста."""
    with open('/etc/hostname', 'w') as f:
        f.write(hostname)
    subprocess.run(['sudo', 'hostnamectl', 'set-hostname', hostname])
    print(f"Имя хоста установлено на {hostname}")

def set_password():
    """Устанавливаем пароль, который берет из файла конфигурации."""
    password = config.PASSWORD
    subprocess.run(['sudo', 'chpasswd'], input=f"root:{password}", text=True)
    print("Пароль установлен.")

if __name__ == "__main__":
    print("Запуск установки VPN...")
    hostname = input("Введите имя хоста для сервера: ")
    set_hostname(hostname)
    set_password()