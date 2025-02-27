# principal.ps1

# Importar los scripts de funciones y mensajes
. .\funciones.ps1
. .\mensajes.ps1

# Mostrar mensaje de inicio
MensajeInicio

# Menú de opciones
while ($true) {
    Write-Host "Selecciona una opción:"
    Write-Host "1. Instalar cliente SSH"
    Write-Host "2. Generar clave SSH"
    Write-Host "3. Copiar clave SSH al servidor"
    Write-Host "4. Conectar al servidor SSH"
    Write-Host "5. Salir"
    $opcion = Read-Host "Opción"

    switch ($opcion) {
        1 {
            InstalarClienteSSH
        }
        2 {
            GenerarClaveSSH
        }
        3 {
            CopiarClaveSSH
        }
        4 {
            ConectarSSH
        }
        5 {
            Write-Host "Saliendo..."
            break
        }
        default {
            Write-Host "Opción no válida. Intenta de nuevo."
        }
    }
}

# Mostrar mensaje de éxito
MensajeExito