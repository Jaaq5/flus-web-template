sudo pacman -S podman
sudo pacman -S podman-docker
podman version

## Por probar

## Utiliza la imagen oficial de PostgreSQL 16 como base
FROM postgres:16

## Definir los argumentos de entorno para las configuraciones predeterminadas de PostgreSQL
## (estos valores pueden ser sobrescritos al crear un contenedor)
ENV POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=secretpassword \
    POSTGRES_DB=mydatabase

## Copiar un archivo de configuración personalizado (opcional)
## Este paso no es obligatorio si estás usando la configuración predeterminada
## COPY ./postgresql.conf /etc/postgresql/postgresql.conf

## Expone el puerto predeterminado de PostgreSQL
EXPOSE 5432

## El contenedor ejecutará PostgreSQL con la configuración personalizada
CMD ["postgres"]

## YML file
version: '3.7'

services:
  # Contenedor para PostgreSQL
  postgres:
    build:
      context: . # Construir desde el Dockerfile en el directorio actual
      dockerfile: Containerfile # Nombre del archivo Containerfile
    container_name: postgres16
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: secretpassword
      POSTGRES_DB: mydatabase
    volumes:
      - postgres_data:/var/lib/postgresql/data # Volumen persistente para los datos
    ports:
      - "5433:5432" # Mapeo del puerto del host al contenedor (host:container)
    networks:
      - app_network
    restart: always # Reinicia el contenedor si falla

  # Contenedor para pgAdmin
  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: adminpassword
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    ports:
      - "8081:80" # Mapeo del puerto para la interfaz web de pgAdmin
    depends_on:
      - postgres # pgAdmin depende de PostgreSQL
    networks:
      - app_network
    restart: always

## Definir volúmenes persistentes
volumes:
  postgres_data: {}
  pgadmin_data: {}

## Definir redes
networks:
  app_network:
    driver: bridge


## Pasos finales de ejecucion
podman build -t postgres:16 .
my-file-compose up -d


# Nuevo
sudo pacman -S --needed podman podman-docker podman-compose cni-plugins
podman version
podman network ls

# Con DeepSeak
chmod -R 700 ./postgres/data
chmod -R 777 ./postgres/data, si no funciona el anterior
psql -h localhost -p 5433 -U mi_usuario -d mi_base_de_datos

## Conexion a PgAdmin4
Pestaña "General":
Name: Un nombre descriptivo para tu servidor (por ejemplo, PostgreSQL Server).

Pestaña "Connection":
Host name/address: postgres16 (el nombre del servicio o del contenedor de PostgreSQL en tu docker-compose.yml).

Port: 5432 (el puerto interno de PostgreSQL, no el mapeado en tu host).

Maintenance database: mi_base_de_datos (el nombre de la base de datos que configuraste en POSTGRES_DB).

Username: mi_usuario (el usuario que configuraste en POSTGRES_USER).

Password: mi_contrasena_segura (la contraseña que configuraste en POSTGRES_PASSWORD).

# Borrar 
podman rm -a
podman rmi -a
podman volume rm -a
podman network rm mi_red


# Verificar uso de espacio
podman system df

