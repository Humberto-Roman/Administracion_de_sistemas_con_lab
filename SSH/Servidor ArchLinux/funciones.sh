#!/bin/bash

# funciones.sh

actualizar_sistema() {
    echo "Actualizando el sistema..."
    sudo pacman -Syu --noconfirm
}

instalar_openssh() {
    echo "Instalando openssh..."
    sudo pacman -S --noconfirm openssh
}

habilitar_servicio_ssh() {
    echo "Habilitando el servicio SSH..."
    sudo systemctl enable sshd
}

iniciar_servicio_ssh() {
    echo "Iniciando el servicio SSH..."
    sudo systemctl start sshd
}

configurar_sshd() {
    echo "Configurando el archivo /etc/ssh/sshd_config..."
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
}

reiniciar_servicio_ssh() {
    echo "Reiniciando el servicio SSH..."
    sudo systemctl restart sshd
}

mostrar_estado_ssh() {
    echo "Mostrando el estado del servicio SSH..."
    sudo systemctl status sshd
}

mostrar_ip() {
    echo "La dirección IP del servidor es:"
    ip a | grep inet
}