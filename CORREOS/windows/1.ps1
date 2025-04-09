$Route = "C:\temp\"
$test=1
$Download=1
$Squirrel=1
$XAMPP=1
$MailEnable=1
mkdir "C:\temp"
mkdir "C:\temp\mail"
#APACHE (XAMPP)
if($XAMPP -eq 1)
{
    #TOMAR EL LINK DE DESCARGA DE https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/7.4.30/xampp-windows-x64-7.4.30-1-VC15.zip/download (descargas el archivo y copias el link del que se descargo)
    $ApacheURI="https://cfhcable.dl.sourceforge.net/project/xampp/XAMPP%20Windows/7.4.30/xampp-windows-x64-7.4.30-1-VC15.zip"
    if($test -eq 1)
    {
        if($Download -eq 1)
        {
            Invoke-WebRequest -URI $ApacheURI -OutFile $Route"xampp.zip"
        }
        mkdir "C:\xampp"
        Expand-Archive -Path "C:\temp\xampp.zip" -DestinationPath "C:\"
        Get-ChildItem -File $Srv_Route"\xampp" -Directory | Rename-Item -NewName {"xampp"}
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://vcredist.com/install.ps1'))
        $error_parse_dir="C:\xampp\php\php.ini"
        $error_parse="error_reporting = E_COMPILE_ERROR|E_RECOVERABLE_ERROR|E_ERROR|E_CORE_ERROR"
        $error_search="error_reporting = E_ALL"
        (gc $error_parse_dir) -replace $error_search, $error_parse | Out-File -encoding ASCII $error_parse_dir
        cd "C:\\xampp"
        echo "" | cmd /c "setup_xampp.bat"
    }
}
#SQUIRRELMAIL
if($Squirrel -eq 1)
{
    #TOMAR EL LINK DE DESCARGA DE https://sourceforge.net/projects/squirrelmail/files/latest/download (descargas el archivo y copias el link del que se descargo)
    $SquirrelURI="https://phoenixnap.dl.sourceforge.net/project/squirrelmail/stable/1.4.22/squirrelmail-webmail-1.4.22.zip"
    $test=1
    $Download=1
    if($test -eq 1)
    {
        if($Download -eq 1)
        {
            Invoke-WebRequest -URI $SquirrelURI -OutFile "C:\temp\squirrelmail-webmail-1.4.22.zip"
        }
        
        #mkdir "C:\temp\mail"
        #tar -xvzf C:\temp\squirrelmail-webmail-1.4.22.zip -C C:\temp\mail
        #Expand-Archive -Path "C:\temp\xampp.zip" -DestinationPath "C:\"
        Expand-Archive -Path "C:\temp\squirrelmail-webmail-1.4.22.zip" -DestinationPath "C:\temp\mail"
        Rename-Item "C:\temp\mail\squirrelmail-webmail-1.4.22" "mail"
        move "C:\temp\mail\mail" "C:\xampp\htdocs"
        copy "C:\xampp\htdocs\mail\config\config_default.php" "C:\xampp\htdocs\mail\config\config.php"
        $data_dir="C:\xampp\htdocs\mail\config\config.php"
        $dir_search="/var/local/squirrelmail/data/"
        $new_dir="C:\xampp\htdocs\mail\data"
        (gc $data_dir) -replace $dir_search, $new_dir | Out-File -encoding ASCII $data_dir
        $attach_dir="C:\xampp\htdocs\mail\config\config.php"
        $dir_attach="/var/local/squirrelmail/attach/"
        $new_attach="C:\xampp\htdocs\mail\attach"
        (gc $attach_dir) -replace $dir_attach, $new_attach | Out-File -encoding ASCII $attach_dir
        mkdir "C:\xampp\htdocs\mail\attach"
        cd "C:\\xampp"
        echo "" | cmd /c "apache_start.bat"
    }
}

#MAILENABLE
if($MailEnable -eq 1)
{
    $EnableURI="https://www.mailenable.com/standard1045.exe"
    $test=1
    $Download=1
    if($test -eq 1)
    {
        if($Download -eq 1)
        {
            Invoke-WebRequest -URI $EnableURI -OutFile "C:\Users\Administrador\download"
            #Invoke-WebRequest -URI "https://www.mailenable.com/standard1045.exe" -OutFile "C:\temp\mail.exe"
        }
    }
}