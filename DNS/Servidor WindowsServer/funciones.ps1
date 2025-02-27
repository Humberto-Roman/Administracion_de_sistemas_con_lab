# funciones.ps1

function InstalarDNSServer {
    if (-not (Get-WindowsFeature -Name DNS).Installed) {
        Write-Host "[+] Instalando el servicio DNS..."
        Install-WindowsFeature -Name DNS -IncludeManagementTools
    } else {
        Write-Host "[!] El servicio DNS ya está instalado."
    }
}

function CrearZonaDirecta {
    param ($Dominio, $IpServer)
    if (Get-DnsServerZone -Name $Dominio -ErrorAction SilentlyContinue) {
        Write-Host "[!] La zona $Dominio ya existe. Eliminándola..."
        Remove-DnsServerZone -Name $Dominio -Confirm:$false
    }
    Write-Host "[+] Creando zona de búsqueda directa..."
    Add-DnsServerPrimaryZone -Name $Dominio -ZoneFile "$Dominio.dns" -DynamicUpdate NonsecureAndSecure
}

function AgregarRegistroA {
    param ($RecordName, $ZoneName, $IpAddress)
    if (-not (Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $RecordName -ErrorAction SilentlyContinue)) {
        Add-DnsServerResourceRecordA -Name $RecordName -ZoneName $ZoneName -IPv4Address $IpAddress -TimeToLive 01:00:00
        Write-Host "[+] Registro A $RecordName agregado en $ZoneName"
    } else {
        Write-Host "[!] El registro A $RecordName ya existe en $ZoneName"
    }
}

function CrearZonaInversa {
    param ($IpInversa, $NetworkId)
    if (-not (Get-DnsServerZone -Name "$IpInversa.in-addr.arpa" -ErrorAction SilentlyContinue)) {
        Add-DnsServerPrimaryZone -NetworkId $NetworkId -ZoneFile "$IpInversa.in-addr.arpa.dns"
        Write-Host "[+] Zona inversa creada"
    } else {
        Write-Host "[!] La zona inversa ya existe"
    }
}

function AgregarRegistroPTR {
    param ($IpUltimoOcteto, $IpInversa, $Dominio)
    if (-not (Get-DnsServerResourceRecord -ZoneName "$IpInversa.in-addr.arpa" -Name $IpUltimoOcteto -ErrorAction SilentlyContinue)) {
        Add-DnsServerResourceRecordPTR -Name $IpUltimoOcteto -ZoneName "$IpInversa.in-addr.arpa" -PtrDomainName "ns.$Dominio"
        Write-Host "[+] Registro PTR agregado"
    } else {
        Write-Host "[!] El registro PTR ya existe"
    }
}

function ReiniciarServicioDNS {
    Write-Host "[+] Reiniciando el servicio DNS..."
    Restart-Service -Name DNS
}