Function leer_puerto {
    $puerto = 0

    while ($puerto -eq 0) {
        $puerto = Read-Host "Puerto para iniciar servicio de Apache"

        $connection = Get-NetTCPConnection -LocalPort $puerto -ErrorAction SilentlyContinue

        if ($connection) {
            Write-Host "El puerto $puerto esta ocupado. Introduce otro puerto."
            $puerto = 0
        }
    }
    return $puerto
}

Function install_nginx {
    $puerto = leer_puerto

    $carpeta = Read-Host "Ubicacion de la carpeta publica"

    $nginxUrl = (Invoke-WebRequest -Uri "https://nginx.org/en/download.html").Links | where href -like "/download*.zip" | Select-Object -Expand href | Select-Object -First 1
    $downloadUrl = "https://nginx.org" + $nginxUrl

    Invoke-WebRequest -Uri $downloadUrl -OutFile "C:\nginx.zip"

    Expand-Archive -Path "C:\nginx.zip" -DestinationPath "C:\nginx"

    New-NetFirewallRule -DisplayName "Nginx Port" -Direction Inbound -Protocol UDP -LocalPort $puerto -Action Allow
    New-NetFirewallRule -DisplayName "Nginx Port" -Direction Inbound -Protocol TCP -LocalPort $puerto -Action Allow

    $archivoConf = "
    worker_processes 1;

    events {
	    worker_connections 1024;
    }

    http {
	    include		mime.types;
	    default_type	application/octet-stream;
	
	    server {
		    listen " + $puerto + ";
		    server_name	localhost;

		    location / {
			    root		"+ $carpeta + ";
			    index	index.html index.htm;
		    }

		    error_page 500 502 503 504 /50x.html;
		    location = /50x.html {
			    root html;
		    }
	    }
    }"

    $version = Get-ChildItem -Path 'C:\nginx\' -Name
    $rutaConf = "C:\nginx\" + $version + "\conf\nginx.conf" 

    $archivoConf | Out-File -FilePath $rutaConf 
    Out-File -FilePath $rutaConf -InputObject $archivoConf -Encoding default

    $rutaStart = "C:\nginx\" + $version
    cd $rutaStart
    invoke-command -Scriptblock {Start nginx.exe}

    Write-Host "Version de Nginx"
    Write-host $version
}


Function install_apache {
    $puerto = leer_puerto

    $carpeta = Read-Host "Ubicacion de la carpeta publica"

    $apacheUrl = (Invoke-WebRequest -Uri "https://www.apachehaus.com/cgi-bin/download.plx").Links | where href -like "/cgi*" | Select-Object -Expand href | Select-Object -First 1
    $dUrl = "https://www.apachehaus.com" + $apacheUrl

    Write-Host "Version a instalar. 1)x86		2)x64"
    $versionApache = Read-Host "Elija una opcion"

    if ($versionApache -eq "1") {
	    $downloadUrl = (Invoke-WebRequest -Uri $dUrl).Links | where href -like "*/downloads/httpd*" | Select-Object -Expand href | Select-Object -First 1
    } else {
	    $downloadUrl = (Invoke-WebRequest -Uri "https://www.apachehaus.com/cgi-bin/download.plx").Links | where href -like "/cgi-bin/download*" | Select-Object -Expand href | Select-Object -index 3
    }

    $downloadUrl = (Invoke-WebRequest -Uri $dUrl).Links | where href -like "*/downloads/httpd*" | Select-Object -Expand href | Select-Object -First 1

    Invoke-WebRequest -Uri $downloadUrl -OutFile "C:\apache.zip"
    Expand-Archive -Path "C:\apache.zip" -DestinationPath "C:\apache"

    New-NetFirewallRule -DisplayName "Apache Port" -Direction Inbound -Protocol UDP -LocalPort $puerto -Action Allow
    New-NetFirewallRule -DisplayName "Apache Port" -Direction Inbound -Protocol TCP -LocalPort $puerto -Action Allow

    $version = Get-ChildItem -Path 'C:\apache' -Name | select-object -First 1

    $srvRoot = "C:\apache\" + $version
    $srvBin = $srvRoot + "\bin\"

    $archivoConf = 'Define SRVROOT "' + $srvRoot + '"
    ServerRoot "' + $srvRoot + '"

    Define ENABLE_TLS13 "Yes"

    Listen ' + $puerto + '

    LoadModule actions_module modules/mod_actions.so
    LoadModule alias_module modules/mod_alias.so
    LoadModule allowmethods_module modules/mod_allowmethods.so
    LoadModule asis_module modules/mod_asis.so
    LoadModule auth_basic_module modules/mod_auth_basic.so
    LoadModule authn_core_module modules/mod_authn_core.so
    LoadModule authn_file_module modules/mod_authn_file.so
    LoadModule authz_core_module modules/mod_authz_core.so
    LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
    LoadModule authz_host_module modules/mod_authz_host.so
    LoadModule authz_user_module modules/mod_authz_user.so
    LoadModule autoindex_module modules/mod_autoindex.so
    LoadModule cgi_module modules/mod_cgi.so
    LoadModule dir_module modules/mod_dir.so
    LoadModule env_module modules/mod_env.so
    LoadModule http2_module modules/mod_http2.so
    LoadModule include_module modules/mod_include.so
    LoadModule info_module modules/mod_info.so
    LoadModule isapi_module modules/mod_isapi.so
    LoadModule log_config_module modules/mod_log_config.so
    LoadModule mime_module modules/mod_mime.so
    LoadModule negotiation_module modules/mod_negotiation.so
    LoadModule setenvif_module modules/mod_setenvif.so
    LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
    LoadModule ssl_module modules/mod_ssl.so
    LoadModule status_module modules/mod_status.so

    <IfModule unixd_module>

    User daemon
    Group daemon

    </IfModule>

    ServerAdmin admin@example.com

    ServerName localhost:' + $puerto + '

    <Directory />
        AllowOverride none
        Require all denied
    </Directory>

    DocumentRoot "' + $carpeta +  '"
    <Directory "' + $carpeta + '">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    <IfModule dir_module>
        DirectoryIndex index.html
    </IfModule>

    <Files ".ht*">
        Require all denied
    </Files>

    ErrorLog "logs/error.log"

    LogLevel warn

    <IfModule log_config_module>
        LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
        LogFormat "%h %l %u %t \"%r\" %>s %b" common

        <IfModule logio_module>
          LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
        </IfModule>

        CustomLog "logs/access.log" common
    </IfModule>

    <IfModule mime_module>
        TypesConfig conf/mime.types
        AddType application/x-compress .Z
        AddType application/x-gzip .gz .tgz
    </IfModule>

    Include conf/extra/httpd-autoindex.conf

    Include conf/extra/httpd-info.conf

    <IfModule proxy_html_module>
    Include conf/extra/httpd-proxy-html.conf
    </IfModule>

    <IfModule ssl_module>
    Include conf/extra/httpd-ahssl.conf
    SSLRandomSeed startup builtin
    SSLRandomSeed connect builtin
    </IfModule>
    <IfModule http2_module>
        ProtocolsHonorOrder On
        Protocols h2 h2c http/1.1
    </IfModule>

    <IfModule lua_module>
      AddHandler lua-script .lua
    </IfModule>'

    $rutaConf = "C:\apache\" + $version + "\conf\httpd.conf" 

    $archivoConf | Out-File -FilePath $rutaConf
    Out-File -FilePath $rutaConf -InputObject $archivoConf -Encoding default


    cd $srvBin
    invoke-command -Scriptblock {httpd -k install}
    invoke-command -Scriptblock {httpd -k runservice}

    Write-Host "Version de apache..."
    httpd -v | Select-Object -First 1 | Write-Host
}

Function install_iis {
    $puerto = leer_puerto

    $carpeta = Read-Host "Ubicacion de la carpeta publica"

    $sitio = Read-Host "Nombre del sitio web"

	Install-WindowsFeature -name Web-Server -IncludeManagementTools

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
}

$opcion = 1

while ($opcion -eq 1) {
    write-host "Instalar servidor http"
    write-host "Opciones"
    write-host "1) IIS"
    write-host "2) Apache"
    write-host "3) Nginx"
    write-host "4) Salir"

    $opcion = read-host "Ingrese una opción"
    if ($opcion -eq "1") {
        install_iis
    } elseif ($opcion -eq "2"){
        install_apache
		$opcion = 1
    } elseif ($opcion -eq "3"){
        install_nginx
		$opcion = 1
    } elseif ($opcion -eq "4"){
        $opcion = 0
    } else {
        write-host "La opcion no es correcta. Elija otra opcion"
        $opcion = 1
    }
}