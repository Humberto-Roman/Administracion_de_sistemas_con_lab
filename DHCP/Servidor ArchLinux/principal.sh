#!/bin/bash

# Importar las funciones y mensajes
source funciones.sh
source mensajes.sh

# Solicitar los datos al usuario
INTERFACE=$(solicitar_interfaz)
SUBNET_NETMASK=$(solicitar_subred)
RANGE=$(solicitar_rango)
GATEWAY=$(solicitar_gateway)
DNS=$(solicitar_dns)

# Separar los valores
SUBNET=$(echo $SUBNET_NETMASK | awk '{print $1}')
NETMASK=$(echo $SUBNET_NETMASK | awk '{print $2}')
RANGE_START=$(echo $RANGE | awk '{print $1}')
RANGE_END=$(echo $RANGE | awk '{print $2}')
DNS1=$(echo $DNS | awk '{print $1}')
DNS2=$(echo $DNS | awk '{print $2}')

# Instalar el servidor DHCP
instalar_dhcp

# Crear la configuración
crear_configuracion $INTERFACE $SUBNET $NETMASK $RANGE_START $RANGE_END $GATEWAY $DNS1 $DNS2

# Configurar el servicio
configurar_servicio $INTERFACE

echo "Servidor DHCP configurado y en funcionamiento."