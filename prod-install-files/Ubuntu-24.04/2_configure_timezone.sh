#!/bin/bash

# Definición de colores
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color (reset)

# Función para configurar la zona horaria
configure_timezone() {
    # Zona horaria deseada
    TARGET_TIMEZONE="America/Costa_Rica"

    echo -e "${ORANGE}Verificando la zona horaria actual...${NC}"
    CURRENT_TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3}')

    if [ "$CURRENT_TIMEZONE" == "$TARGET_TIMEZONE" ]; then
        echo -e "${GREEN}La zona horaria ya está configurada en $TARGET_TIMEZONE.${NC}"
        return 0
    fi

    echo -e "${ORANGE}Configurando la zona horaria a $TARGET_TIMEZONE...${NC}"
    sudo timedatectl set-timezone $TARGET_TIMEZONE
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Zona horaria configurada correctamente a $TARGET_TIMEZONE.${NC}"
    else
        echo -e "${RED}Error al configurar la zona horaria.${NC}"
        exit 1
    fi

    echo -e "${ORANGE}Verificando la nueva configuración de zona horaria...${NC}"
    NEW_TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3}')
    if [ "$NEW_TIMEZONE" == "$TARGET_TIMEZONE" ]; then
        echo -e "${GREEN}La zona horaria se ha actualizado correctamente a $TARGET_TIMEZONE.${NC}"
    else
        echo -e "${RED}La zona horaria no se ha actualizado correctamente.${NC}"
        exit 1
    fi
}

# Ejecutar la función principal
configure_timezone

echo -e "${GREEN}¡La configuración de la zona horaria se ha completado con éxito!${NC}"
