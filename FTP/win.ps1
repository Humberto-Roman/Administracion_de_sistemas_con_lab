Function leer_puerto {
    $puerto = 0

    while ($puerto -eq 0) {
        $puerto = Read-Host "cual sera el puerto para iniciar el servicio"

        $connection = Get-NetTCPConnection -LocalPort $puerto -ErrorAction SilentlyContinue

        if ($connection) {
            Write-Host "El puerto $puerto esta ocupado. Introduce otro puerto."
            $puerto = 0
        }
    }
    return $puerto
}

Function install_filezilla {
    $link = (Invoke-WebRequest -Uri 'https://www.filehorse.com/es/descargar-filezilla-server/versiones-previas/').Links | Where-Object {$_.innerHTML -like "FileZilla Server *"} | Select -ExpandProperty href

    $vers = (Invoke-WebRequest -Uri 'https://www.filehorse.com/es/descargar-filezilla-server/versiones-previas/').Links | Where-Object {$_.innerHTML -like "FileZilla Server *"} | Select -ExpandProperty innerHTML
    Write-Host "VERSIONES:"
    "1.-" + $vers[1]
    "2.-" + $vers[2]
    "3.-" + $vers[3]

    $op = Read-Host "Elige el numero de la versión a instalar"

    if ( $op -eq '1' )
    {
        $li = (Invoke-WebRequest -Uri $link[1]).Links | Where-Object {$_.innerText -like "Descargar Libre"} | Select -ExpandProperty href
    } elseif ( $op -eq '2' )
    {
        $li = (Invoke-WebRequest -Uri $link[2]).Links | Where-Object {$_.innerText -like "Descargar Libre"} | Select -ExpandProperty href
    }
     elseif ( $op -eq '3' )
    {
        $li = (Invoke-WebRequest -Uri $link[3]).Links | Where-Object {$_.innerText -like "Descargar Libre"} | Select -ExpandProperty href
    }

    $desc = (Invoke-WebRequest -Uri $li[0]).Links | Where-Object {$_.innerText -like "Descargar Ahora"} | Select -ExpandProperty href

    Invoke-WebRequest -Uri $desc -OutFile "C:\Users\Administrador\Downloads\filezilla-server.exe"
    Start-Process C:\Users\Administrador\Downloads\filezilla-server.exe
}

Function install_coreftp {
    $link = (Invoke-WebRequest -Uri 'http://coreftp.com/server/download/archive/').Links | Where-Object {$_.innerText -like "CoreFTPServer*x64*"} | Select -ExpandProperty href

    $vers = (Invoke-WebRequest -Uri 'http://coreftp.com/server/download/archive/').Links | Where-Object {$_.innerText -like "CoreFTPServer*x64*"} | Select -ExpandProperty innerText
    Write-Host "VERSIONES:"
    "1.-" + $vers[0]
    "2.-" + $vers[1]
    "3.-" + $vers[2]

    $op = Read-Host "Elige el numero de la versión a instalar"

    if ( $op -eq '1' )
    {
        $desc = "coreftp.com" + $link[0]
        Invoke-WebRequest -Uri $desc -OutFile "C:\Users\Administrador\Downloads\coreftp.exe"
    } elseif ( $op -eq '2' )
    {
        $desc = "coreftp.com" + $link[1]
        Invoke-WebRequest -Uri $desc -OutFile "C:\Users\Administrador\Downloads\coreftp.exe"
    }
     elseif ( $op -eq '3' )
    {
        $desc = "coreftp.com" + $link[2]
        Invoke-WebRequest -Uri $desc -OutFile "C:\Users\Administrador\Downloads\coreftp.exe"
    }

    Start-Process C:\Users\Administrador\Downloads\coreftp.exe
}

Function install_iis {
    $puerto = leer_puerto
    $ruta = Read-Host "Ruta"
    $carp = Read-Host "Nombre de carpeta raiz"
    $usr = Read-Host "Usuario"
    $pass = Read-Host "Contraseña"

    Install-WindowsFeature Web-FTP-Server -IncludeAllSubFeature
    Install-WindowsFeature Web-Basic-Auth
    mkdir $ruta/$carp
    cd $ruta/$carp
    
    $phys = Get-Location
    New-WebFtpSite -Name "FTP" -Port $puerto -PhysicalPath $phys

    $FTPUserGroupName = "GrupoFTP"
    $ADSI = [ADSI]"WinNT://$env:ComputerName"
    $FTPUserGroup = $ADSI.Create("Group", "$FTPUserGroupName")
    $FTPUserGroup.SetInfo()
    $FTPUserGroup.Description = "Los miembros de este grupo podrán acceder al servidor FTP"
    $FTPUserGroup.SetInfo()

    $FTPUserName = $usr
    $FTPPassword = $pass
    $CreateUserFTPUser = $ADSI.Create("User", "$FTPUserName")
    $CreateUserFTPUser.SetInfo()
    $CreateUserFTPUser.SetPassword("$FTPPassword")
    $CreateUserFTPUser.SetInfo()

    $UserAccount = New-Object System.Security.Principal.NTAccount("$FTPUserName")
    $SID = $UserAccount.Translate([System.Security.Principal.SecurityIdentifier])
    $Group = [ADSI]"WinNT://$env:ComputerName/$FTPUserGroupName,Group"
    $User = [ADSI]"WinNT://$SID"
    $Group.Add($User.Path)

    Set-ItemProperty "IIS:\Sites\FTP" -Name ftpServer.security.authentication.basicAuthentication.enabled -Value $true

    Add-WebConfiguration "/system.ftpServer/security/authorization" -value @{accessType="Allow";roles="GrupoFTP";permissions=3} -PSPath IIS:\ -location "FTP"
    Set-ItemProperty "IIS:\Sites\FTP" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0
    Set-ItemProperty "IIS:\Sites\FTP" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0

    Restart-WebItem "IIS:\Sites\FTP"
}

$opcion = 1

while ($opcion -eq 1) {
    write-host "Instalar servidor FTP"
    write-host "Opciones"
    write-host "1) IIS"
    write-host "2) Filezilla"
    write-host "3) CoreFTP"
    write-host "4) Salir"

    $opcion = read-host "Ingrese una opción"
    if ($opcion -eq "1") {
        install_iis
    } elseif ($opcion -eq "2"){
        install_filezilla
        $opcion = 1
    } elseif ($opcion -eq "3"){
        install_coreftp
        $opcion = 1
    } elseif ($opcion -eq "4"){
        $opcion = 0
    } else {
        write-host "La opcion no es correcta. Elija otra opcion"
        $opcion = 1
    }
}
