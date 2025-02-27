# funciones.ps1

function InstalarDHCP {
    if (-not (Get-WindowsFeature -Name 'DHCP').Installed) {
        Write-Host "[+] Instalando el rol DHCP..."
        Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools
    } else {
        Write-Host "[!] El rol DHCP ya está instalado."
    }
}

function AutorizarEnAD {
    if (Get-Command Get-ADDomain -ErrorAction SilentlyContinue) {
        if ((Get-ADDomain -ErrorAction SilentlyContinue) -ne $null) {
            Write-Host "[+] Autorizando el servidor DHCP en Active Directory..."
            Add-DhcpServerInDC
        } else {
            Write-Host "[!] El servidor no está en un dominio. Se omite la autorización en Active Directory." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[!] Advertencia: No se encontró el módulo de Active Directory, se omite Add-DhcpServerInDC." -ForegroundColor Yellow
    }
}

function EliminarAmbitoExistente {
    param ($ScopeNetwork)
    if (Get-DhcpServerv4Scope -ScopeId $ScopeNetwork -ErrorAction SilentlyContinue) {
        Write-Host "[!] El ámbito $ScopeNetwork ya existe. Eliminándolo..." -ForegroundColor Yellow
        Remove-DhcpServerv4Scope -ScopeId $ScopeNetwork -Confirm:$false
        Start-Sleep -Seconds 3  # Esperar para evitar errores
    }
}

function CrearAmbitoDHCP {
    param ($ScopeName, $ScopeNetwork, $ScopeStart, $ScopeEnd, $SubnetMask)
    Write-Host "[+] Creando un nuevo ámbito DHCP..."
    Add-DhcpServerv4Scope -Name $ScopeName -StartRange $ScopeStart -EndRange $ScopeEnd -SubnetMask $SubnetMask -State Active
}

function ConfigurarOpcionesDHCP {
    param ($ScopeNetwork, $Gateway, $DNSServer, $LeaseDuration)
    Write-Host "[+] Configurando la puerta de enlace..."
    Set-DhcpServerv4OptionValue -ScopeId $ScopeNetwork -OptionId 3 -Value $Gateway

    Write-Host "[+] Configurando el servidor DNS..."
    Set-DhcpServerv4OptionValue -ScopeId $ScopeNetwork -OptionId 6 -Value $DNSServer

    Write-Host "[+] Configurando la duración del arrendamiento..."
    Set-DhcpServerv4Scope -ScopeId $ScopeNetwork -LeaseDuration ([TimeSpan]::FromDays($LeaseDuration))
}

function IniciarServicioDHCP {
    Write-Host "[+] Iniciando y habilitando el servicio DHCP..."
    Restart-Service dhcpserver
    Set-Service dhcpserver -StartupType Automatic
}
