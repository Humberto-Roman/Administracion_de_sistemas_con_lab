#!/bin/bash

# Función para solicitar la interfaz de red
solicitar_interfaz() {
    read -p "Ingrese la interfaz de red a utilizar (ejemplo: enp0s3): " INTERFACE
    echo $INTERFACE
}

# Función para solicitar la subred y máscara
solicitar_subred() {
    read -p "Ingrese la subred (ejemplo: 192.168.1.0): " SUBNET
    read -p "Ingrese la máscara de subred (ejemplo: 255.255.255.0): " NETMASK
    echo "$SUBNET $NETMASK"
}

# Función para solicitar el rango de direcciones IP
solicitar_rango() {
    read -p "Ingrese la IP inicial del rango (ejemplo: 192.168.1.100): " RANGE_START
    read -p "Ingrese la IP final del rango (ejemplo: 192.168.1.200): " RANGE_END
    echo "$RANGE_START $RANGE_END"
}

# Función para solicitar la puerta de enlace
solicitar_gateway() {
    read -p "Ingrese la IP del gateway (ejemplo: 192.168.1.1): " GATEWAY
    echo $GATEWAY
}

# Función para solicitar los servidores DNS
solicitar_dns() {
    read -p "Ingrese el primer servidor DNS (ejemplo: 8.8.8.8): " DNS1
    read -p "Ingrese el segundo servidor DNS (opcional, ejemplo: 8.8.4.4): " DNS2
    echo "$DNS1 $DNS2"
}