# mensajes.ps1

function MensajeInicio {
    Write-Host "¡Bienvenido al script de configuración del cliente SSH en Windows Server 2025!"
}

function MensajeExito {
    Write-Host "¡Cliente SSH configurado y listo para usar!"
}

function MensajeError {
    Write-Host "Hubo un error durante la configuración. Por favor, revisa los logs."
}