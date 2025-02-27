# principal.ps1

# Importar los scripts de funciones y mensajes
. .\funciones.ps1
. .\mensajes.ps1

# Función para validar una subred en formato CIDR
function ValidarSubred {
    param ($Subred)
    return $Subred -match "^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$"
}

# Función para validar una dirección IP
function ValidarIp {
    param ($Ip)
    return $Ip -match "^(\d{1,3}\.){3}\d{1,3}$"
}

# Función para validar un nombre de dominio
function ValidarDominio {
    param ($Dominio)
    return $Dominio -match "^[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$"
}

# Mostrar mensaje de inicio
MensajeInicio

# Solicitar y validar la subred
do {
    $Subred = Read-Host "Introduzca la subred (ej. 192.168.1.0/24)"
    if (-not (ValidarSubred $Subred)) {
        MensajeSubredInvalida
    }
} until (ValidarSubred $Subred)

# Solicitar y validar la IP del servidor DNS
do {
    $IpServer = Read-Host "Introduzca la IP del servidor DNS"
    if (-not (ValidarIp $IpServer)) {
        MensajeIpInvalida
    }
} until (ValidarIp $IpServer)

# Solicitar y validar el nombre del dominio
do {
    $Dominio = Read-Host "Introduzca el nombre del dominio"
    if (-not (ValidarDominio $Dominio)) {
        MensajeDominioInvalido
    }
} until (ValidarDominio $Dominio)

# Calcular la dirección inversa y la red de la subred
$IpPartes = $IpServer -split "\."
$IpInversa = "$($IpPartes[2]).$($IpPartes[1]).$($IpPartes[0])"
$NetworkId = "$($IpPartes[0]).$($IpPartes[1]).$($IpPartes[2]).0/24"

# Cargar el módulo DNS
Import-Module DnsServer

# Ejecutar las funciones
InstalarDNSServer
CrearZonaDirecta -Dominio $Dominio -IpServer $IpServer
AgregarRegistroA -RecordName "ns" -ZoneName $Dominio -IpAddress $IpServer
AgregarRegistroA -RecordName "www" -ZoneName $Dominio -IpAddress $IpServer
AgregarRegistroA -RecordName $Dominio -ZoneName $Dominio -IpAddress $IpServer
CrearZonaInversa -IpInversa $IpInversa -NetworkId $NetworkId
AgregarRegistroPTR -IpUltimoOcteto $IpPartes[3] -IpInversa $IpInversa -Dominio $Dominio
ReiniciarServicioDNS

# Mostrar mensaje de éxito
MensajeExito