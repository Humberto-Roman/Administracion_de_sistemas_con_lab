#!/bin/bash

# funciones.sh

instalar_cliente_ssh() {
    echo "Instalando el cliente SSH..."
    sudo pacman -S --noconfirm openssh
}

generar_clave_ssh() {
    echo "Generando una clave SSH..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
    echo "¡Clave SSH generada!"
}

copiar_clave_ssh() {
    echo "Ingresa la dirección IP del servidor SSH:"
    read server_ip
    echo "Ingresa el nombre de usuario en el servidor SSH:"
    read username
    echo "Copiando la clave SSH al servidor..."
    ssh-copy-id -i ~/.ssh/id_rsa.pub "$username@$server_ip"
    echo "¡Clave SSH copiada al servidor!"
}

conectar_ssh() {
    echo "Ingresa la dirección IP del servidor SSH:"
    read server_ip
    echo "Ingresa el nombre de usuario en el servidor SSH:"
    read username
    echo "Conectando al servidor SSH..."
    ssh "$username@$server_ip"
}