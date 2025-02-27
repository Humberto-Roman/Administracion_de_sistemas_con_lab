#!/bin/bash

# funciones.sh

instalar_bind() {
    echo "Instalando BIND (servidor DNS)..."
    sudo pacman -S --noconfirm bind
}

configurar_bind() {
    echo "Configurando BIND..."
    sudo cp /etc/named.conf /etc/named.conf.backup
    sudo sed -i 's/127.0.0.1;/any;/g' /etc/named.conf
    sudo sed -i 's/localhost;/any;/g' /etc/named.conf
    echo "¡Configuración de BIND completada!"
}

crear_zona() {
    local dominio="$1"
    local ip="$2"

    echo "Creando zona para el dominio $dominio..."
    sudo cat <<EOF | sudo tee -a /etc/named.conf > /dev/null
zone "$dominio" {
    type master;
    file "/var/named/$dominio.zone";
};
EOF

    sudo cat <<EOF | sudo tee /var/named/$dominio.zone > /dev/null
\$TTL 86400
@       IN      SOA     ns1.$dominio. admin.$dominio. (
                        2023101001 ; Serial
                        3600       ; Refresh
                        1800       ; Retry
                        1209600    ; Expire
                        86400 )    ; Minimum TTL

        IN      NS      ns1.$dominio.
ns1     IN      A       $ip
@       IN      A       $ip
EOF

    echo "¡Zona creada para el dominio $dominio!"
}

reiniciar_bind() {
    echo "Reiniciando BIND..."
    sudo systemctl restart named
    sudo systemctl enable named
    echo "¡BIND reiniciado y habilitado!"
}

verificar_configuracion() {
    echo "Verificando la configuración de BIND..."
    named-checkconf /etc/named.conf
    if [ $? -eq 0 ]; then
        echo "La configuración de BIND es válida."
    else
        echo "Error en la configuración de BIND."
        exit 1
    fi
}