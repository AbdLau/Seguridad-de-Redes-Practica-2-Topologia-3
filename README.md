# Infraestructura 3: VPN Remote-Site (SSL-VPN) con FortiGate

## 🎥 Video demostrativo

**[Ver video en YouTube](https://www.youtube.com/watch?v=03Dq_PRPTKk)**

> Autor: **Erick Abdiel Laureano Martinez** | Matrícula: **2025-0846** | Asignatura: Seguridad de Redes

---

## Tabla de contenido
1. [Propósito del laboratorio](#propósito-del-laboratorio)
2. [Diagrama de la topología](#diagrama-de-la-topología)
3. [Direccionamiento IP](#direccionamiento-ip)
4. [Configuración de red](#configuración-de-red)
5. [Servidor web y SSH](#servidor-web-y-ssh)
6. [Usuarios: DHCP y traceroute](#usuarios-dhcp-y-traceroute)
7. [Acceso web sin VPN](#acceso-web-sin-vpn)
8. [Configuración de la VPN SSL](#configuración-de-la-vpn-ssl)
9. [Acceso SSH mediante VPN](#acceso-ssh-mediante-vpn)
10. [Evidencias y logs](#evidencias-y-logs)
11. [Running-configs y scripts](#running-configs-y-scripts)

---

## Propósito del laboratorio

Demostrar una VPN de acceso remoto (cliente a sitio) con un FortiGate, configurada completamente por la GUI. Los objetivos son:

- El usuario **accede al servidor web sin necesidad de VPN**.
- El usuario **accede al servidor por SSH únicamente a través de la VPN**.

La topología incluye un equipo de red Cisco (R2) con la VLAN 10 de usuarios y DHCP, un ISP con IPs públicas, un servidor web (/28) y un FortiGate que publica el web y termina la VPN SSL.

---

## Diagrama de la topología

```mermaid
flowchart TB
    ISP(("Cloud1 (ISP)<br/>200.8.46.0/24<br/>GW 200.8.46.2"))
    R2["Cisco-R2<br/>Gi1/0 200.8.46.134"]
    FG["FortiGate-1<br/>port2 (G0/1) 200.8.46.135"]
    U["User1-1 (VLAN 10)<br/>10.8.46.0/25"]
    S["WebServer2-1<br/>10.8.46.130/28"]
    C["Cliente VPN<br/>openconnect"]

    ISP ---|"eth0"| R2
    ISP ---|"eth1"| FG
    R2 ---|"Fa0/0.10<br/>10.8.46.1"| U
    FG ---|"port1 (G0/0)<br/>10.8.46.129"| S
    C -.->|"SSL-VPN 10443"| FG
```

![Topología en GNS3](<img width="418" height="420" alt="01-topologia-gns3" src="https://github.com/user-attachments/assets/9a974ab5-645b-4af9-a747-c576875f2151" />)

---

## Direccionamiento IP

| Dispositivo | Interfaz | Dirección | Notas |
|---|---|---|---|
| FortiGate | port2 (WAN) | 200.8.46.135/24 | Hacia el ISP |
| FortiGate | port1 (LAN servidor) | 10.8.46.129/28 | Gateway del servidor |
| Cisco-R2 | Gi1/0 | 200.8.46.134 | Hacia el ISP / FortiGate |
| Cisco-R2 | Fa0/0.10 | 10.8.46.1/25 | Gateway VLAN 10 de usuarios |
| Servidor web | eth0 | 10.8.46.130/28 | Apache + SSH |
| ISP | | 200.8.46.2 | Gateway por defecto |
| Cliente VPN | túnel | 10.8.46.200 | Asignada por la SSL-VPN |

---

## Configuración de red

### Interfaces del FortiGate
![Interfaces](<img width="1107" height="549" alt="02-interfaces-fortigate" src="https://github.com/user-attachments/assets/6e28ac47-596c-4021-995a-91488793e779" />)

### Rutas estáticas
Ruta por defecto hacia el ISP (200.8.46.2) y ruta a la red de usuarios (10.8.46.0/25) vía R2 (200.8.46.134).

![Rutas estáticas](<img width="1098" height="174" alt="03-rutas-estaticas" src="https://github.com/user-attachments/assets/55ca8625-c539-49c3-a272-6299991ca30a" />)

### Cisco-R2
![R2 interfaces y rutas](<img width="665" height="419" alt="04-r2-interfaces-rutas" src="https://github.com/user-attachments/assets/47cd9310-d833-47c8-a8d1-59cb3958b165" />)

Subinterfaz de la VLAN 10:

![R2 subinterfaz VLAN 10](<img width="660" height="168" alt="05-r2-subinterfaz-vlan10" src="https://github.com/user-attachments/assets/8855c5c4-8fad-49e1-93d2-1ba6b3177dd2" />)

---

## Servidor web y SSH

El servidor ejecuta Apache (DVWA) y OpenSSH.

![Servicios del servidor](<img width="1108" height="285" alt="08-servidor-servicios" src="https://github.com/user-attachments/assets/160376b9-8c3d-4d87-b484-5668cf6c7918" />)

---

## Usuarios: DHCP y traceroute

Los usuarios están en la VLAN 10 y obtienen IP por DHCP.

![Usuario con DHCP](<img width="689" height="366" alt="06-usuarios-dhcp" src="https://github.com/user-attachments/assets/23b172d3-d125-44ea-a24c-7aef6c0f8e31" />)

Traceroute hacia el servidor (R2 → FortiGate → servidor):

![Traceroute](<img width="570" height="94" alt="07-traceroute-servidor" src="https://github.com/user-attachments/assets/7cd6c117-798f-437e-b070-d5028ee39a30" />)

---

## Acceso web sin VPN

El web se publica con un Virtual IP (DNAT) y una política de firewall en el FortiGate, por lo que el acceso no requiere VPN.

![Virtual IPs](<img width="1210" height="168" alt="09-virtual-ip" src="https://github.com/user-attachments/assets/98f47cdf-3809-4919-924b-0dd9b6841a6c" />)

![Políticas de firewall](<img width="1365" height="436" alt="10-politicas-firewall" src="https://github.com/user-attachments/assets/85b3bd58-3865-44dd-b235-d60f95e83704" />)

![Acceso web sin VPN](<img width="604" height="345" alt="12-web-sin-vpn" src="https://github.com/user-attachments/assets/d51d977b-9cda-4ea0-b39c-1c91e18578de" />)

El SSH sin VPN no está permitido:

![SSH sin VPN falla](<img width="740" height="199" alt="13-ssh-sin-vpn-falla" src="https://github.com/user-attachments/assets/604a9ae9-9884-4fbc-b4f6-5d52526dc968" />)

---

## Configuración de la VPN SSL

- Interfaz de escucha: **port2**
- Puerto: **10443**
- Portal: **full-access** (modo túnel)
- Usuario: **usuario1**
- Pool de direcciones: **VPN_POOL**

![SSL-VPN Settings](<img width="757" height="595" alt="14-ssl-vpn-settings" src="https://github.com/user-attachments/assets/41205eb3-edc4-4eff-ae47-c4f9c41c8d11" />)

![SSL-VPN Portal](<img width="677" height="631" alt="15-ssl-vpn-portal" src="https://github.com/user-attachments/assets/83339e75-b33c-498f-8134-9462c489785e" />)

![Usuario VPN](img/16-usuario-vpn.png)

### Política que permite SSH solo por la VPN
`SSLVPN_TO_SERVER`: ssl.root → port1, origen VPN_POOL + usuario1, destino SERVER_WEB, servicio SSH.

![Política SSH por VPN](img/11-politica-ssh-vpn.png)

---

## Acceso SSH mediante VPN

Conexión desde el cliente con `openconnect`:

```bash
OPENSSL_CONF=/tmp/o.cnf openconnect -b --protocol=fortinet \
  https://200.8.46.135:10443 --user=usuario1 \
  --servercert pin-sha256:<HUELLA_DEL_CERTIFICADO>
ssh root@10.8.46.130
```

![openconnect conectado](img/17-openconnect-conectado.png)

![SSH con VPN](img/18-ssh-con-vpn.png)

> **Nota:** el cliente usa OpenSSL 3.5, que envía grupos post-cuánticos que el FortiGate no negocia. El archivo `scripts/o.cnf` limita TLS a 1.2 y a los grupos X25519/secp256r1.

---

## Evidencias y logs

Usuario conectado en el monitor de SSL-VPN:

![Monitor SSL-VPN](img/19-ssl-vpn-monitor.png)

Tráfico aceptado (HTTP sin VPN y SSH por VPN):

![Forward Traffic](img/20-logs-forward-traffic.png)

---

## Running-configs y scripts

```
├── README.md
├── configs/
│   ├── fortigate-running-config.conf
│   └── cisco-r2-running-config.txt
├── scripts/
│   ├── o.cnf                      # TLS 1.2 para openconnect
│   ├── conectar-vpn.sh            # Conexión openconnect + ssh
│   ├── webserver-network.txt      # Config de red del Docker (Edit config)
│   └── webserver-ssh.sh           # Instalación y arranque de SSH
└── img/
```

- [FortiGate running-config](configs/fortigate-running-config.conf)
- [Cisco-R2 running-config](configs/cisco-r2-running-config.txt)
- [Scripts](scripts/)

> Las contraseñas, los hashes y las claves precompartidas fueron removidos de las configuraciones.
