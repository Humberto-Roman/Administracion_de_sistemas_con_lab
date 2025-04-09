$puerto = 0

while ($puerto -eq 0) {
    $puerto = Read-Host "Puerto para iniciar servicio de Apache"

    $connection = Get-NetTCPConnection -LocalPort $puerto -ErrorAction SilentlyContinue

    if ($connection) {
        Write-Host "El puerto $puerto esta ocupado. Introduce otro puerto."
        $puerto = 0
    }
}

$carpeta = Read-Host "Ubicacion de la carpeta publica"

$sitio = Read-Host "Nombre del sitio web"

$appPool = New-WebAppPool -Name “c”
$appPool.managedRuntimeVersion = “v4.0”
$appPool.managedPipelineMode = “Integrated”

$appPool | Set-Item

$website = New-Website -Name $sitio -PhysicalPath $carpeta -ApplicationPool ($appPool.Name)

$identidadIIS = "IIS AppPool\" + $sitio
$carpetaACL = Get-Acl $carpeta
$permisos = [System.Security.AccessControl.FileSystemAccessRule]::new($identidadIIS, "ReadAndExecute", "Allow")
$carpetaACL.SetAccessRule($permisos)
Set-Acl -Path $carpeta -AclObject $carpetaACL

Set-ItemProperty IIS:\sites\$sitio -Name enabledProtocols -Value "http"

Set-WebBinding -Name $sitio -PropertyName "Port" -Value $puerto

Start-WebSite $sitio