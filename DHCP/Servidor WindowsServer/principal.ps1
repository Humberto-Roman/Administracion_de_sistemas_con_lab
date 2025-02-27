# principal.ps1

# Importar los scripts de funciones y mensajes
. .\funciones.ps1
. .\mensajes.ps1

# Función para validar una dirección IP
function ValidarIp {
    param ($Ip)
    return $Ip -match "^(\d{1,3}\.){3}\d{1,3}$"
}

# Función para validar una máscara de subred
function ValidarMascara {
    param ($Mascara)
    return $Mascara -match "^(\d{1,3}\.){3}\d{1,3}$"
}

# Función para validar un número entero
function ValidarEntero {
    param ($Numero)
    return $Numero -match "^\d+$"
}

# Mostrar mensaje de inicio
MensajeInicio

# Solicitar datos al usuario con validaciones
do {
    $ScopeName = Read-Host "Nombre del Ámbito DHCP"
    if ([string]::IsNullOrWhiteSpace($ScopeName)) {
        Write-Host "[❌] Error: El nombre del ámbito no puede estar vacío." -ForegroundColor Red
    }
} until (-not [string]::IsNullOrWhiteSpace($ScopeName))

do {
    $ScopeNetwork = Read-Host "Dirección de red del Ámbito (ej. 192.168.100.0)"
    if (-not (ValidarIp $ScopeNetwork)) {
        MensajeSubredInvalida
    }
} until (ValidarIp $ScopeNetwork)

do {
    $ScopeStart = Read-Host "Inicio del Rango de IP (ej. 192.168.100.100)"
    if (-not (ValidarIp $ScopeStart)) {
        MensajeIpInvalida
    }
} until (ValidarIp $ScopeStart)

do {
    $ScopeEnd = Read-Host "Fin del Rango de IP (ej. 192.168.100.200)"
    if (-not (ValidarIp $ScopeEnd)) {
        MensajeIpInvalida
    }
} until (ValidarIp $ScopeEnd)

do {
    $SubnetMask = Read-Host "Máscara de Subred (ej. 255.255.255.0)"
    if (-not (ValidarMascara $SubnetMask)) {
        MensajeMascaraInvalida
    }
} until (ValidarMascara $SubnetMask)

do {
    $Gateway = Read-Host "Puerta de Enlace (ej. 192.168.100.1)"
    if (-not (ValidarIp $Gateway)) {
        MensajeIpInvalida
    }
} until (ValidarIp $Gateway)

do {
    $DNSServer = Read-Host "Servidor DNS (ej. 192.168.100.1)"
    if (-not (ValidarIp $DNSServer)) {
        MensajeIpInvalida
    }
} until (ValidarIp $DNSServer)

do {
    $LeaseDuration = Read-Host "Duración de la concesión en días (ej. 8)"
    if (-not (ValidarEntero $LeaseDuration)) {
        MensajeDuracionInvalida
    }
} until (ValidarEntero $LeaseDuration)

# Ejecutar las funciones
InstalarDHCP
AutorizarEnAD
EliminarAmbitoExistente -ScopeNetwork $ScopeNetwork
CrearAmbitoDHCP -ScopeName $ScopeName -ScopeNetwork $ScopeNetwork -ScopeStart $ScopeStart -ScopeEnd $ScopeEnd -SubnetMask $SubnetMask
ConfigurarOpcionesDHCP -ScopeNetwork $ScopeNetwork -Gateway $Gateway -DNSServer $DNSServer -LeaseDuration $LeaseDuration
IniciarServicioDHCP

# Mostrar mensaje de éxito
MensajeExito
