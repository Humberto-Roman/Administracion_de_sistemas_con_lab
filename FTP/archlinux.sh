sudo apt-get update
opcion=1

sudo mkdir /var/ftp
sudo groupadd reprobados

while [ $opcion -eq 1 ]
do
	echo "Instalar servidores FTP"
	echo "Opciones"
	echo "1) vsftpd"
	echo "2) proftpd"
	echo "3) pureftpd"
	echo "4) Salir"
	read -p "Elija una opción: " opc

	if [ $opc -ge 1 ] && [ $opc -le 3 ]
	then
		read -p "Introduce el puerto en el que se iniciará el servicio: " puerto
		read -p "Introduce el nombre de la carpeta donde se crearán los directorios: " carpeta

		sudo mkdir /var/ftp/$carpeta
		sudo mkdir /var/ftp/$carpeta/reprobados
		sudo chown nobody:reprobados /var/ftp/$carpeta/reprobados
		sudo chmod 770 /var/ftp/$carpeta/reprobados

		sudo mkdir /var/ftp/$carpeta/publica
		sudo chown nobody:nogroup /var/ftp/$carpeta/publica
		sudo chmod 777 /var/ftp/$carpeta/publica

		read -p "Ingrese la lista de usuarios separados por coma: " usuarios

		for usuario in $(echo $usuarios | tr "," "\n")
		do
			echo "Contraseña del usuario $usuario"
			sudo useradd -g reprobados -m -s /bin/bash $usuario
			sudo passwd $usuario
			sudo mkdir /var/ftp/$carpeta/$usuario
			sudo chown $usuario:reprobados /var/ftp/$carpeta/$usuario
			sudo chmod 700 /var/ftp/$carpeta/$usuario
		done
	fi

	if [ $opc -eq 1 ]
	then
		sudo apt-get install vsftpd -y

		sudo ufw allow $puerto/tcp
		sudo ufw allow $puerto/udp

		sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
		sudo echo "listen=NO
		listen_ipv6=YES
		anonymous_enable=YES
		local_enable=YES
		write_enable=YES
		dirmessage_enable=YES
		use_localtime=YES
		xferlog_enable=YES
		connect_from_port_20=YES
		chroot_local_user=YES

		secure_chroot_dir=/var/run/vsftpd/empty
		pam_service_name=vsftpd

		rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
		rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
		ssl_enable=NO

		allow_writeable_chroot=YES
		user_sub_token=$USER
		local_root=/var/ftp/$carpeta

		userlist_enable=YES
		userlist_file=/etc/vsftpd.userlist
		userlist_deny=NO

		listen_port=$puerto" > /etc/vsftpd.conf

		for usuario in $(echo $usuarios | tr "," "\n")
		do
			sudo echo $usuario >> /etc/vsftpd.userlist
		done

		sudo echo "grisel" >> /etc/vsftpd.userlist
		sudo service vsftpd restart

		echo "La carpeta de inicio del servidor vsftpd se encuentra en /var/ftp/$carpeta"
	elif [ $opc -eq 2 ]
	then
		sudo apt-get install proftpd -y

		sudo ufw allow $puerto/tcp
		sudo ufw allow $puerto/udp

		sudo systemctl start proftpd

		sudo chmod 600 /etc/ssl/private/proftpd.key
		sudo chmod 600 /etc/ssl/certs/proftpd.crt

		sudo echo "Include /etc/proftpd/modules.conf
		Port 			$puerto

		User			nobody
		Group			nogroup

		UseIPv6			on
		ServerName		'Ubuntu'
		ServerType		standalone
		DeferWelcome		off
		DefaultRoot		/var/ftp/$carpeta" > /etc/proftpd/proftpd.conf

		sudo systemctl restart proftpd
		opcion=1
		echo "La carpeta de inicio del servidor proftpd se encuentra en /var/ftp/$carpeta"
	elif [ $opc -eq 3 ]
	then
		sudo apt-get install pure-ftpd

		sudo ufw allow $puerto/tcp
		sudo ufw allow $puerto/udp

		for usuario in $(echo $usuarios | tr "," "\n")
		do
			sudo usermod -d /var/ftp/$carpeta $usuario
		done
		sudo service pure-ftpd restart
		opcion=1
	elif [ $opc -eq 4 ]
	then
		opcion=0
	else
		echo "La opción ingresada no es válida. Ingrese otra opción"
		opcion=1
	fi
done
