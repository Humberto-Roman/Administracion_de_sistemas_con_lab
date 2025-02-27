#!/bin/bash

# principal.sh

# Importar los scripts de funciones y mensajes
source funciones.sh
source mensajes.sh

# Función para validar un dominio
validar_dominio() {
    local dominio="$1"
    if [[ "$dominio" =~ ^[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Función para validar una dirección IP
validar_ip() {
    local ip="$1"
    if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Mostrar mensaje de inicio
mensaje_inicio

# Solicitar dominio y validar
while true; do
    read -p "Ingresa el dominio (ejemplo: midominio.com): " dominio
    if validar_dominio "$dominio"; then
        break
    else
        mensaje_dominio_invalido
    fi
done

# Solicitar dirección IP y validar
while true; do
    read -p "Ingresa la dirección IP del servidor (ejemplo: 192.168.1.100): " ip
    if validar_ip "$ip"; then
        break
    else
        mensaje_ip_invalida
    fi
done

# Ejecutar las funciones
instalar_bind
configurar_bind
crear_zona "$dominio" "$ip"
verificar_configuracion
reiniciar_bind

# Mostrar mensaje de éxito
mensaje_exito