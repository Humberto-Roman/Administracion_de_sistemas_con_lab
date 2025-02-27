#!/bin/bash

# Función para instalar el servidor DHCP
instalar_dhcp() {
    if ! pacman -Q dhcp &>/dev/null; then
        echo "Instalando el servidor DHCP..."
        sudo pacman -Sy --noconfirm dhcp
    fi
}

# Función para crear el archivo de configuración
crear_configuracion() {
    local INTERFACE=$1
    local SUBNET=$2
    local NETMASK=$3
    local RANGE_START=$4
    local RANGE_END=$5
    local GATEWAY=$6
    local DNS1=$7
    local DNS2=$8

    sudo tee /etc/dhcpd.conf > /dev/null <<EOL
default-lease-time 600;
max-lease-time 7200;
authoritative;
subnet $SUBNET netmask $NETMASK {
    range $RANGE_START $RANGE_END;
    option routers $GATEWAY;
    option domain-name-servers $DNS1, $DNS2;
}
EOL

    sudo chown dhcpd:dhcpd /etc/dhcpd.conf
    sudo chmod 644 /etc/dhcpd.conf
}

# Función para configurar el servicio DHCP
configurar_servicio() {
    local INTERFACE=$1

    sudo mkdir -p /etc/systemd/system/dhcpd4.service.d
    sudo tee /etc/systemd/system/dhcpd4.service.d/override.conf > /dev/null <<EOL
[Service]
ExecStart=
ExecStart=/usr/bin/dhcpd -4 -q -cf /etc/dhcpd.conf -pf /run/dhcpd4/dhcpd.pid $INTERFACE
EOL

    sudo systemctl daemon-reload
    sudo systemctl enable --now dhcpd4.service
}