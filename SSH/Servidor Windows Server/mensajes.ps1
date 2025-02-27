# mensajes.ps1

function MensajeInicio {
    Write-Host "¡Bienvenido al script de configuración de SSH en Windows Server 2025!"
}

function MensajeExito {
    Write-Host "¡Servidor SSH configurado y listo para usar!"
}

function MensajeError {
    Write-Host "Hubo un error durante la configuración. Por favor, revisa los logs."
}