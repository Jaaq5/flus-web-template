#!/bin/bash

# Definición de colores
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Función para verificar si un comando está disponible
function check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Función para mostrar un mensaje y eliminar una línea en ~/.bashrc
function remove_from_bashrc() {
    sed -i "$1" ~/.bashrc
    source ~/.bashrc
}

# Forzar el tipo de terminal para que funcione 'clear' sin errores
export TERM=xterm

clear

# Bucle principal
while true; do
    # Limpiar la pantalla

    echo ""
    echo -e "${GREEN}Welcome to the optional vm settings installer${NC}"

    # Menú de opciones
    echo ""
    echo "Select an option:"
    echo "1. Install settings"
    echo "2. Uninstall settings"
    echo "3. Exit"
    read -p "Enter your choice [1-3]: " choice
    echo ""

    case $choice in
        1)
            # Actualizar el sistema y verificar/instalar paquetes necesarios
            echo "Updating the system and installing necessary packages..."

            # Actualizar el índice de paquetes
            sudo apt update -y > /dev/null 2>&1
            echo -e "${GREEN}System updated${NC}"
            echo ""

            # Paquetes necesarios
            packages=("git" "curl" "make" "gawk" "vim" "nano")

            for pkg in "${packages[@]}"; do
                if ! check_command $pkg; then
                    echo -e "${ORANGE}${pkg} not found. Installing ${pkg}...${NC}"
                    sudo apt install -y $pkg > /dev/null 2>&1
                else
                    echo -e "${ORANGE}${pkg} is already installed${NC}"
                fi
            done

            echo ""
            # Instalación de Starship
            echo "Installing starship (customizable shell prompt)..."

            if check_command starship; then
                echo -e "${ORANGE}Starship already installed${NC}"
                starship --version
            else
                # Crear el directorio ~/.local/bin si no existe
                mkdir -p ~/.local/bin

                # Intentar instalar starship en ~/.local/bin sin usar sudo y sin pedir confirmación
                echo "Downloading and installing Starship..."
                curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin --yes > /dev/null

                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Starship installed successfully in ~/.local/bin${NC}"

                    # Agregar ~/.local/bin al PATH si no está ya incluido
                    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                        echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
                        echo -e "${GREEN}Starship path added to ~/.bashrc${NC}"
                    fi

                    # Añadir la inicialización de Starship al final de ~/.bashrc
                    if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc; then
                        echo 'eval "$(starship init bash)"' >> ~/.bashrc
                        echo -e "${GREEN}Starship initialization added to ~/.bashrc${NC}"
                    fi

                else
                    echo -e "${RED}Starship installation failed (error)${NC}"
                fi
            fi

            # Instalación de ble.sh
            echo ""
            echo "Installing ble.sh (command line editor)..."

            if [ -d ~/.local/share/blesh ]; then
                echo -e "${ORANGE}ble.sh already installed${NC}"
            else

                # Clonar el repositorio de ble.sh
                echo "Cloning ble.sh repository..."
                git clone --recursive https://github.com/akinomyoga/ble.sh.git ~/.local/src/ble.sh > /dev/null 2>&1
                echo -e "${GREEN}ble.sh repository cloned${NC}"

                # Construir e instalar ble.sh
                cd ~/.local/src/ble.sh

                echo "Building ble.sh..."
                if make > /dev/null; then
                    echo -e "${GREEN}ble.sh built successfully${NC}"

                    # Instalar ble.sh
                    echo "Installing ble.sh..."
                    if make install > /dev/null; then
                        echo -e "${GREEN}ble.sh installed successfully${NC}"

                        # Añadir la configuración de ble.sh a ~/.bashrc
                        if ! grep -q 'source ~/.local/share/blesh/ble.sh --noattach' ~/.bashrc; then
                            echo '[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --noattach' >> ~/.bashrc
                            echo -e "${GREEN}ble.sh configuration added to ~/.bashrc${NC}"
                        fi

                        # Añadir la línea de ble-attach al final de ~/.bashrc
                        if ! grep -q '[[ ! ${BLE_VERSION-} ]] || ble-attach' ~/.bashrc; then
                            echo '[[ ! ${BLE_VERSION-} ]] || ble-attach' >> ~/.bashrc
                            echo -e "${GREEN}ble.sh attachment added to ~/.bashrc${NC}"
                        fi

                    else
                        echo -e "${RED}ble.sh installation failed (error)${NC}"
                    fi
                else
                    echo -e "${RED}ble.sh build failed (error)${NC}"
                fi
            fi

            # Instalación de lsd
            echo ""
            echo "Installing lsd (colorful ls replacement)..."

            if check_command lsd; then
                echo -e "${ORANGE}lsd already installed${NC}"
            else
                # Instalar lsd
                echo "Installing lsd..."
                sudo apt install -y lsd > /dev/null 2>&1

                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}lsd installed successfully${NC}"

                    # Añadir alias para lsd a ~/.bashrc
                    if ! grep -q 'alias ls="lsd"' ~/.bashrc; then
                        echo 'alias ls="lsd"' >> ~/.bashrc
                        echo -e "${GREEN}Alias 'ls' set to 'lsd' in ~/.bashrc${NC}"
                    fi

                else
                    echo -e "${RED}lsd installation failed (error)${NC}"
                fi
            fi

            # Instalación de bat
            echo ""
            echo "Installing bat (enhanced cat command)..."

            if check_command batcat; then
                echo -e "${ORANGE}bat already installed${NC}"
            else
                # Instalar bat
                echo "Installing bat..."
                sudo apt install -y bat > /dev/null 2>&1

                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}bat installed successfully${NC}"

                    # Añadir alias para cat a ~/.bashrc
                    if ! grep -q 'alias cat="batcat"' ~/.bashrc; then
                        echo 'alias cat="batcat"' >> ~/.bashrc
                        echo -e "${GREEN}Alias 'cat' set to 'batcat' in ~/.bashrc${NC}"
                    fi

                else
                    echo -e "${RED}bat installation failed (error)${NC}"
                fi
            fi

            echo ""
            # Añadir export TERM=xterm-256color al ~/.bashrc si no está ya incluido
            if ! grep -q 'export TERM=xterm-256color' ~/.bashrc; then
                echo 'export TERM=xterm-256color' >> ~/.bashrc
                echo -e "${GREEN}TERM=xterm-256color added to ~/.bashrc${NC}"
            fi

            echo ""
            # Recargar ~/.bashrc para aplicar los cambios
            source ~/.bashrc
            echo -e "${GREEN}~/.bashrc reloaded${NC}"
            echo ""
            echo -e "${GREEN}Exit the instance and enter again to see the changes${NC}"
            exit 0

            ;;

        2)
            # Desinstalar Starship
            echo ""
            if check_command starship; then
                echo "Uninstalling Starship..."
                rm -f ~/.local/bin/starship
                remove_from_bashrc '/eval "$(starship init bash)"/d'
                echo -e "${GREEN}Starship uninstalled successfully${NC}"
            else
                echo -e "${ORANGE}Starship is not installed${NC}"
            fi

            echo ""
            # Desinstalar ble.sh
            if [ -d ~/.local/share/blesh ]; then
                echo "Uninstalling ble.sh..."
                rm -rf ~/.local/share/blesh
                rm -rf ~/.local/src/ble.sh
                remove_from_bashrc '/source ~\/.local\/share\/blesh\/ble.sh --noattach/d'
                remove_from_bashrc '/ble-attach/d'
                echo -e "${GREEN}ble.sh uninstalled successfully${NC}"
            else
                echo -e "${ORANGE}ble.sh is not installed${NC}"
            fi

            echo ""
            # Desinstalar lsd y eliminar el alias
            if check_command lsd; then
                echo "Uninstalling lsd..."
                sudo apt remove -y lsd > /dev/null 2>&1
                remove_from_bashrc '/alias ls="lsd"/d'
                echo -e "${GREEN}lsd uninstalled successfully${NC}"
            else
                echo -e "${ORANGE}lsd is not installed${NC}"
            fi

            echo ""
            # Desinstalar bat y eliminar el alias
            if check_command batcat; then
                echo "Uninstalling bat..."
                sudo apt remove -y bat > /dev/null 2>&1
                remove_from_bashrc '/alias cat="batcat"/d'
                echo -e "${GREEN}bat uninstalled successfully${NC}"
            else
                echo -e "${ORANGE}bat is not installed${NC}"
            fi

            # Eliminar export TERM=xterm-256color del ~/.bashrc si está incluido
            remove_from_bashrc '/export TERM=xterm-256color/d'


            echo ""
            # Recargar ~/.bashrc para aplicar los cambios
            source ~/.bashrc
            echo -e "${GREEN}~/.bashrc reloaded${NC}"
            echo -e "${GREEN}Exit the instance and enter again to see the changes${NC}"
            ;;

        3)
            echo -e "${GREEN}Exiting.${NC}"
            exit 0
            ;;

        *)
            echo -e "${RED}Invalid choice! Please select a valid option.${NC}"
            ;;
    esac
done
