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

Write-Host "Version de Nginx"
Write-host $version

$rutaExe = $rutaConf = "C:\nginx\" + $version

cd $rutaExe
start nginx.exe

