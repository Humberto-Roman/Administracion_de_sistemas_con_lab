# mensajes.ps1

function MensajeInicio {
    Write-Host "¡Bienvenido al script de configuración del servidor DNS en Windows Server 2025!"
}

function MensajeExito {
    Write-Host "[✅] Servidor DNS configurado correctamente en Windows Server 2025."
}

function MensajeError {
    Write-Host "[❌] Hubo un error durante la configuración. Por favor, revisa los logs."
}

function MensajeSubredInvalida {
    Write-Host "[❌] Error: La subred ingresada no es válida. Debe estar en formato CIDR (ej. 192.168.1.0/24)."
}

function MensajeIpInvalida {
    Write-Host "[❌] Error: La dirección IP ingresada no es válida."
}

function MensajeDominioInvalido {
    Write-Host "[❌] Error: El nombre del dominio ingresado no es válido."
}