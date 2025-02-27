# funciones.ps1

function ActualizarSistema {
    Write-Host "Actualizando el sistema..."
    Install-WindowsFeature -Name UpdateServices -IncludeManagementTools
}

function InstalarOpenSSH {
    Write-Host "Instalando OpenSSH..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

function HabilitarServicioSSH {
    Write-Host "Habilitando el servicio SSH..."
    Set-Service -Name sshd -StartupType Automatic
}

function IniciarServicioSSH {
    Write-Host "Iniciando el servicio SSH..."
    Start-Service -Name sshd
}

function ConfigurarSSH {
    Write-Host "Configurando el servidor SSH..."
    # Deshabilitar el acceso root (en Windows, esto se traduce a deshabilitar el acceso administrativo)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name "PermitRootLogin" -Value "no"
    # Deshabilitar la autenticación por contraseña
    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name "PasswordAuthentication" -Value "no"
}

function ReiniciarServicioSSH {
    Write-Host "Reiniciando el servicio SSH..."
    Restart-Service -Name sshd
}

function MostrarEstadoSSH {
    Write-Host "Mostrando el estado del servicio SSH..."
    Get-Service -Name sshd
}

function MostrarIP {
    Write-Host "La dirección IP del servidor es:"
    Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' } | Select-Object IPAddress
}