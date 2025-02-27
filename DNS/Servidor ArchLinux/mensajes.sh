#!/bin/bash

# mensajes.sh

mensaje_inicio() {
    echo "¡Bienvenido al script de configuración del servidor DNS en Arch Linux!"
}

mensaje_exito() {
    echo "¡Servidor DNS configurado y listo para usar!"
}

mensaje_error() {
    echo "Hubo un error durante la configuración. Por favor, revisa los logs."
}

mensaje_dominio_invalido() {
    echo "Error: El dominio ingresado no es válido."
}

mensaje_ip_invalida() {
    echo "Error: La dirección IP ingresada no es válida."
}