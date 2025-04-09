#Primero chequeamos el ping
sudo apt install apache2 -y
sudo apt install php libapache2-mod-php php-mysql -y
sudo apt-get install postfix -y
sudo apt-get install courier-pop -y #Decimos que NO a la opcion que pregunta
sudo apt-get install courier-imap -y
sudo apt-get install mailutils -y
sudo apt-get install postfix-policyd-spf-python -y
sudo apt-get install dovecot-imapd dovecot-pop3d -y
sudo apt install wget -y

sudo dpkg-reconfigure postfix

sudo ufw allow in "Apache"
cd /home/grisel/Downloads
#descargar squirrelmail
#sudo wget https://www.squirrelmail.org/countdl.php?fileurl=http%3A%2F%2Fsnapshots.squirrelmail.org%2Fsquirrelmail-20230517_0200-SVN.devel.tar.bz2
sudo tar --bzip2 -xvf /home/grisel/Downloads/squirrelmail-20230521_0200-SVN.devel.tar.bz2
sudo mv squirrelmail.devel squirrelmail

sudo mv squirrelmail /var/www/

sudo sed -i "s%/var/www/html%/var/www/squirrelmail%g" /etc/apache2/sites-available/000-default.conf

sudo adduser paco
# ponemos el password, despues 
sudo adduser paco mail

sudo chmod 777 /etc/dovecot/dovecot.conf

sudo echo "protocols = pop3 imap
mail_location = maildir:~/Maildir" >> /etc/dovecot/dovecot.conf

sudo echo "-----BEGIN CERTIFICATE-----
MIIDIDCCAomgAwIBAgIENd70zzANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UE
ChMHRXF1aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
MB4XDTk4MDgyMjE2NDE1MVoXDTE4MDgyMjE2NDE1MVowTjELMAkGA1UEBhMCVVMxEDAOBgNVBAoT
B0VxdWlmYXgxLTArBgNVBAsTJEVxdWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTCB
nzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAwV2xWGcIYu6gmi0fCG2RFGiYCh7+2gRvE4RiIcPR
fM6fBeC4AfBONOziipUEZKzxa1NfBbPLZ4C/QgKO/t0BCezhABRP/PvwDN1Dulsr4R+AcJkVV5MW
8Q+XarfCaCMczE1ZMKxRHjuvK9buY0V7xdlfUNLjUA86iOe/FP3gx7kCAwEAAaOCAQkwggEFMHAG
A1UdHwRpMGcwZaBjoGGkXzBdMQswCQYDVQQGEwJVUzEQMA4GA1UEChMHRXF1aWZheDEtMCsGA1UE
CxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MQ0wCwYDVQQDEwRDUkwxMBoG
A1UdEAQTMBGBDzIwMTgwODIyMTY0MTUxWjALBgNVHQ8EBAMCAQYwHwYDVR0jBBgwFoAUSOZo+SvS
spXXR9gjIBBPM5iQn9QwHQYDVR0OBBYEFEjmaPkr0rKV10fYIyAQTzOYkJ/UMAwGA1UdEwQFMAMB
Af8wGgYJKoZIhvZ9B0EABA0wCxsFVjMuMGMDAgbAMA0GCSqGSIb3DQEBBQUAA4GBAFjOKer89961
zgK5F7WF0bnj4JXMJTENAKaSbn+2kmOeUJXRmm/kEd5jhW6Y7qj/WsjTVbJmcVfewCHrPSqnI0kB
BIZCe/zuf6IWUrVnZ9NA2zsmWLIodz2uFHdh1voqZiegDfqnc1zqcPGUIWVEX/r87yloqaKHee95
70+sB3c4
-----END CERTIFICATE-----" >> /etc/postfix/cacert.pem

sudo echo "[smtp.gmail.com]:587 usuario@gmail.com:contraseña" >> /etc/postfix/sasl/passwd
sudo chmod 600 /etc/postfix/sasl/passwd
sudo postmap /etc/postfix/sasl/passwd

sudo echo "127.0.0.1	grisel.com
192.198.0.70	grisel.com" >> /etc/hosts

sudo echo "policy-spf  unix  -       n       n       -       -       spawn
  user=nobody argv=/usr/bin/policyd-spf" >> /etc/postfix/master.cf

sudo mkdir /var/www/squirrelmail/data
sudo chmod 775 /var/www/squirrelmail/
sudo chmod -R 775 /var/www/squirrelmail/data/
sudo chown -R www-data:www-data /var/www/squirrelmail/
sudo service apache2 restart

sudo echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf

sudo /etc/init.d/dovecot restart
sudo /etc/init.d/postfix restart

sudo perl /var/www/squirrelmail/config/conf.pl
