#!/bin/bash

# Definición de colores
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color (reset)

# Función para verificar y desinstalar firewalls previos
remove_existing_firewalls() {
    echo -e "${ORANGE}Verificando firewalls instalados...${NC}"

    if command -v ufw &> /dev/null; then
        echo -e "${RED}Desinstalando UFW...${NC}"
        sudo systemctl stop ufw
        sudo apt remove --purge -y ufw
        sudo rm -rf /etc/ufw
    fi

    if command -v iptables &> /dev/null; then
        echo -e "${RED}Restableciendo y desinstalando iptables...${NC}"
        sudo iptables --flush
        sudo iptables -X
        sudo iptables -Z
        sudo iptables -t nat --flush
        sudo iptables -t mangle --flush
        sudo apt remove --purge -y iptables
    fi

    echo -e "${GREEN}Firewalls anteriores eliminados.${NC}"
}

# Función para instalar y configurar firewalld
install_firewalld() {
    echo -e "${ORANGE}Instalando firewalld...${NC}"
    sudo apt install -y firewalld

    echo -e "${ORANGE}Habilitando y arrancando firewalld...${NC}"
    sudo systemctl enable firewalld
    sudo systemctl start firewalld

    echo -e "${ORANGE}Configurando reglas de firewall...${NC}"
    sudo firewall-cmd --permanent --add-service=ssh
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --permanent --add-service=ftp
    #sudo firewall-cmd --permanent --add-service=smtp
    #sudo firewall-cmd --permanent --add-service=imap
    #sudo firewall-cmd --permanent --add-service=imaps
    #sudo firewall-cmd --permanent --add-service=pop3
    #sudo firewall-cmd --permanent --add-service=pop3s
    sudo firewall-cmd --permanent --add-service=dns
    #sudo firewall-cmd --permanent --add-port=3306/tcp  # MySQL/MariaDB

    echo -e "${GREEN}Aplicando cambios...${NC}"
    sudo firewall-cmd --reload

    echo -e "${GREEN}firewalld instalado y configurado correctamente.${NC}"
}

# Ejecutar funciones
remove_existing_firewalls
install_firewalld

echo -e "${GREEN}¡Configuración de firewall completada!${NC}"
