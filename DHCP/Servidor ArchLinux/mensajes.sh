#!/bin/bash

# Función para validar una dirección IP
validar_ip() {
    local ip=$1
    local regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if [[ $ip =~ $regex ]]; then
        return 0
    else
        return 1
    fi
}

# Función para validar una máscara de subred
validar_netmask() {
    local netmask=$1
    local regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if [[ $netmask =~ $regex ]]; then
        return 0
    else
        return 1
    fi
}

# Función para validar una interfaz de red
validar_interfaz() {
    local interfaz=$1
    if ip link show "$interfaz" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Función para solicitar la interfaz de red
solicitar_interfaz() {
    while true; do
        read -p "Ingrese la interfaz de red a utilizar (ejemplo: enp0s3): " INTERFACE
        if validar_interfaz "$INTERFACE"; then
            echo "$INTERFACE"
            break
        else
            echo "Error: La interfaz '$INTERFACE' no existe. Intente nuevamente."
        fi
    done
}

# Función para solicitar la subred y máscara
solicitar_subred() {
    while true; do
        read -p "Ingrese la subred (ejemplo: 192.168.1.0): " SUBNET
        if validar_ip "$SUBNET"; then
            break
        else
            echo "Error: La subred '$SUBNET' no tiene un formato válido. Intente nuevamente."
        fi
    done

    while true; do
        read -p "Ingrese la máscara de subred (ejemplo: 255.255.255.0): " NETMASK
        if validar_netmask "$NETMASK"; then
            break
        else
            echo "Error: La máscara de subred '$NETMASK' no tiene un formato válido. Intente nuevamente."
        fi
    done

    echo "$SUBNET $NETMASK"
}

# Función para solicitar el rango de direcciones IP
solicitar_rango() {
    while true; do
        read -p "Ingrese la IP inicial del rango (ejemplo: 192.168.1.100): " RANGE_START
        if validar_ip "$RANGE_START"; then
            break
        else
            echo "Error: La IP inicial '$RANGE_START' no tiene un formato válido. Intente nuevamente."
        fi
    done

    while true; do
        read -p "Ingrese la IP final del rango (ejemplo: 192.168.1.200): " RANGE_END
        if validar_ip "$RANGE_END"; then
            break
        else
            echo "Error: La IP final '$RANGE_END' no tiene un formato válido. Intente nuevamente."
        fi
    done

    echo "$RANGE_START $RANGE_END"
}

# Función para solicitar la puerta de enlace
solicitar_gateway() {
    while true; do
        read -p "Ingrese la IP del gateway (ejemplo: 192.168.1.1): " GATEWAY
        if validar_ip "$GATEWAY"; then
            echo "$GATEWAY"
            break
        else
            echo "Error: La IP del gateway '$GATEWAY' no tiene un formato válido. Intente nuevamente."
        fi
    done
}

# Función para solicitar los servidores DNS
solicitar_dns() {
    while true; do
        read -p "Ingrese el primer servidor DNS (ejemplo: 8.8.8.8): " DNS1
        if validar_ip "$DNS1"; then
            break
        else
            echo "Error: El servidor DNS '$DNS1' no tiene un formato válido. Intente nuevamente."
        fi
    done

    while true; do
        read -p "Ingrese el segundo servidor DNS (opcional, ejemplo: 8.8.4.4): " DNS2
        if [[ -z "$DNS2" ]] || validar_ip "$DNS2"; then
            break
        else
            echo "Error: El servidor DNS '$DNS2' no tiene un formato válido. Intente nuevamente."
        fi
    done

    echo "$DNS1 $DNS2"
}
