#!/bin/bash

# mensajes.sh

mensaje_inicio() {
    echo "¡Bienvenido al script de configuración del cliente SSH en Arch Linux!"
}

mensaje_exito() {
    echo "¡Cliente SSH configurado y listo para usar!"
}

mensaje_error() {
    echo "Hubo un error durante la configuración. Por favor, revisa los logs."
}