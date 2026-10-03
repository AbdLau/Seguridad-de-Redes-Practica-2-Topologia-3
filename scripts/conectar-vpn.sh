#!/bin/sh
# Conecta la SSL-VPN del FortiGate con openconnect y abre SSH al servidor.
# Requiere o.cnf en /tmp (TLS 1.2 para evitar el fallo con OpenSSL 3.5).
cp o.cnf /tmp/o.cnf
OPENSSL_CONF=/tmp/o.cnf openconnect -b --protocol=fortinet \
  https://200.8.46.135:10443 --user=usuario1 \
  --servercert pin-sha256:HUELLA_DEL_CERTIFICADO
ssh root@10.8.46.130
