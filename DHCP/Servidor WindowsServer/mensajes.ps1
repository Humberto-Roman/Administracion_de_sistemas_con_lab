# mensajes.ps1

function MensajeInicio {
    Write-Host "¡Bienvenido al script de configuración del servidor DHCP en Windows Server 2025!"
}

function MensajeExito {
    Write-Host "[✅] Servidor DHCP configurado correctamente y en ejecución." -ForegroundColor Green
}

function MensajeError {
    Write-Host "[❌] Hubo un error durante la configuración. Por favor, revisa los logs." -ForegroundColor Red
}

function MensajeSubredInvalida {
    Write-Host "[❌] Error: La dirección de red ingresada no es válida. Debe estar en formato CIDR (ej. 192.168.1.0/24)." -ForegroundColor Red
}

function MensajeIpInvalida {
    Write-Host "[❌] Error: La dirección IP ingresada no es válida." -ForegroundColor Red
}

function MensajeMascaraInvalida {
    Write-Host "[❌] Error: La máscara de subred ingresada no es válida." -ForegroundColor Red
}

function MensajeDuracionInvalida {
    Write-Host "[❌] Error: La duración de la concesión debe ser un número entero." -ForegroundColor Red
}
