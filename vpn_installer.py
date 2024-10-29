# vpn_installer/vpn_installer/vpn_installer.py
import subprocess
import os

def set_hostname(hostname):
    """Устанавливаем имя хоста."""
    with open('/etc/hostname', 'w') as f:
        f.write(hostname)
    subprocess.run(['sudo', 'hostnamectl', 'set-hostname', hostname])
    print(f"Имя хоста установлено на {hostname}")

if __name__ == "__main__":
    print("Запуск установки VPN...")
    hostname = input("Введите имя хоста для сервера: ")
    set_hostname(hostname)