#!/bin/sh
# Instala y habilita SSH en el contenedor del servidor web.
which sshd || (sed -i 's/deb.debian.org/archive.debian.org/;s|security.debian.org|archive.debian.org|' /etc/apt/sources.list && apt-get update && apt-get install -y openssh-server)
echo 'root:CAMBIAR_PASSWORD' | chpasswd
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
mkdir -p /var/run/sshd
service ssh restart || /usr/sbin/sshd
service apache2 start
