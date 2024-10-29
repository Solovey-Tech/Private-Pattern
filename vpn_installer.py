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

def update_and_upgrade():
    """Обновляем и обновляем систему."""
    try:
        subprocess.run(['sudo', 'apt-get', 'update'], check=True)
        subprocess.run(['sudo', 'apt-get', 'upgrade', '-y'], check=True)
        print("Обновления установлены")
    except subprocess.CalledProcessError as e:
        print(f"Ошибка при обновлении системы: {e}")

def install_3x_ui():
    """Устанавливаем 3x-ui."""
    try:
        subprocess.run(['bash', '<(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)'], shell=True, check=True)
        print("Установка прошла успешно, ядро x-ui установлено, панель 3x-ui установлено")
    except subprocess.CalledProcessError as e:
        print(f"Ошибка при установке 3x-ui: {e}")

if __name__ == "__main__":
    print("Запуск установки VPN...")
    hostname = input("Введите имя хоста для сервера: ")
    set_hostname(hostname)
    set_password()
    update_and_upgrade()
    install_3x_ui()