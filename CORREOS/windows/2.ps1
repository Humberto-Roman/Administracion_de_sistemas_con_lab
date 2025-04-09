import-module servermanager

Add-WindowsFeature SMTP-Server, Web-Mgmt-Console,WEB-WMI

Start-Service SMTPSVC
Set-Service SMTPSVC -StartupType Automatic
Start-Service SMTPSVC
Get-Service SMTPSVC

Set-Location C:\Windows\System32\inetsrv
.\InetMgr6.exe
Install-WindowsFeature -Name Telnet-Client

C:\temp\mail.exe