#!/bin/bash

# principal.sh

# Importar los scripts de funciones y mensajes
source funciones.sh
source mensajes.sh

# Mostrar mensaje de inicio
mensaje_inicio

# Ejecutar las funciones
actualizar_sistema
instalar_openssh
habilitar_servicio_ssh
iniciar_servicio_ssh
configurar_sshd
reiniciar_servicio_ssh
mostrar_estado_ssh
mostrar_ip

# Mostrar mensaje de éxito
mensaje_exito