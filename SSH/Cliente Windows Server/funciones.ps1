# funciones.ps1

function InstalarClienteSSH {
    Write-Host "Instalando el cliente SSH..."
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
}

function GenerarClaveSSH {
    Write-Host "Generando una clave SSH..."
    $sshDir = "$env:USERPROFILE\.ssh"
    if (-not (Test-Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir
    }
    ssh-keygen -t rsa -b 4096 -f "$sshDir\id_rsa" -N ""
    Write-Host "¡Clave SSH generada en $sshDir!"
}

function CopiarClaveSSH {
    Write-Host "Ingresa la dirección IP del servidor SSH:"
    $server_ip = Read-Host
    Write-Host "Ingresa el nombre de usuario en el servidor SSH:"
    $username = Read-Host
    Write-Host "Copiando la clave SSH al servidor..."
    $sshDir = "$env:USERPROFILE\.ssh"
    type "$sshDir\id_rsa.pub" | ssh "$username@$server_ip" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
    Write-Host "¡Clave SSH copiada al servidor!"
}

function ConectarSSH {
    Write-Host "Ingresa la dirección IP del servidor SSH:"
    $server_ip = Read-Host
    Write-Host "Ingresa el nombre de usuario en el servidor SSH:"
    $username = Read-Host
    Write-Host "Conectando al servidor SSH..."
    ssh "$username@$server_ip"
}