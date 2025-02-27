#!/bin/bash

# mensajes.sh

mensaje_inicio() {
    echo "¡Bienvenido al script de configuración de SSH!"
}

mensaje_exito() {
    echo "¡Servidor SSH configurado y listo para usar!"
}

mensaje_error() {
    echo "Hubo un error durante la configuración. Por favor, revisa los logs."
}