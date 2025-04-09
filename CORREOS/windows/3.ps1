Add-PSSnapin MailEnable.Provision.Command
Get-MailEnablePostoffice

$dmn = Read-Host -Prompt "escriba su dominio"
$continue = $true

while ($continue) {
    $usr1 = Read-Host -Prompt "Escriba su usuario"
    $pass1 = Read-Host -Prompt "Escriba su contraseña"

    New-MailEnableMailbox -Mailboxes $usr1 -Domains $dmn -Password $pass1 -Right "USER"

    $choice = Read-Host -Prompt "¿Desea agregar otro usuario? (S/N)"
    if ($choice -ne "S") {
        $continue = $false
    }
}