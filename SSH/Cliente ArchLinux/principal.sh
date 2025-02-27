#!/bin/bash

# principal.sh

# Importar los scripts de funciones y mensajes
source funciones.sh
source mensajes.sh

# Mostrar mensaje de inicio
mensaje_inicio

# Menú de opciones
while true; do
    echo "Selecciona una opción:"
    echo "1. Instalar cliente SSH"
    echo "2. Generar clave SSH"
    echo "3. Copiar clave SSH al servidor"
    echo "4. Conectar al servidor SSH"
    echo "5. Salir"
    read -p "Opción: " opcion

    case $opcion in
        1)
            instalar_cliente_ssh
            ;;
        2)
            generar_clave_ssh
            ;;
        3)
            copiar_clave_ssh
            ;;
        4)
            conectar_ssh
            ;;
        5)
            echo "Saliendo..."
            break
            ;;
        *)
            echo "Opción no válida. Intenta de nuevo."
            ;;
    esac
done

# Mostrar mensaje de éxito
mensaje_exito