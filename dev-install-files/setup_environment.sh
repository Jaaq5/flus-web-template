#!/bin/bash

# Clean terminal
bash
clear

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root o con sudo."
  exit 1
fi

echo "Actualizando los repositorios e instalando los paquetes necesarios..."

# Actualiza los repositorios y el sistema
# pacman -Syu --noconfirm

# Instala herramientas básicas de desarrollo
pacman -S --needed --noconfirm base-devel git curl wget unzip python gcc make

# Instala Node.js y npm
pacman -S --needed --noconfirm nodejs npm

# Instala Nvm
# Verifica si NVM está instalado
if [ -d "$HOME/.nvm" ]; then
  echo "NVM ya está instalado, saltando instalación."
else
  echo "NVM no está instalado, procediendo a la instalación..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  source ~/.bashrc
  nvm install 22
fi

# Instala PostgreSQL
pacman -S --needed --noconfirm postgresql

# Instala Nginx
pacman -S --needed --noconfirm nginx

# Mensaje final
echo "La instalación de los paquetes necesarios ha finalizado."
echo "Recuerda configurar PostgreSQL, Nginx y otros servicios según sea necesario."



