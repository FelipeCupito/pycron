# Pycron

Pycron es una herramienta simple basada en Python para ejecutar tareas periódicas definidas por el usuario. Es especialmente útil en entornos Docker donde `cron` puede ser difícil de manejar.

## Tabla de Contenidos

- [Introducción](#introducción)
- [Comparación con Cron](#comparación-con-cron)
- [Instalación desde GitHub](#instalación-desde-github)
- [Uso](#uso)
  - [Desde la Terminal](#desde-la-terminal)
  - [Con Docker](#con-docker)
  - [Con Docker Compose](#con-docker-compose)
- [Extensión del Dockerfile](#extensión-del-dockerfile)
- [Licencia](#licencia)

## Introducción

Pycron es una herramienta que permite ejecutar comandos de manera periódica utilizando Python, lo cual facilita su integración y manejo en contenedores Docker. Proporciona una alternativa a `cron` con la flexibilidad de configuración y manejo de tareas que Python ofrece.

## Comparación con Cron

### Pros de Pycron
- **Fácil Integración en Docker**: No requiere configuraciones adicionales para correr en contenedores Docker.
- **Configuración Sencilla**: Utiliza archivos de configuración en formato YAML.
- **Manejo de Errores**: Permite manejar errores y reintentar tareas fallidas. (Próximamente)
- **Flexibilidad**: Al estar basado en Python, es fácil de extender y modificar según necesidades específicas.

### Contras de Pycron
- **Limitaciones de Funcionalidad**: Puede no tener todas las funcionalidades avanzadas de `cron`.
- **Dependencias**: Requiere tener Python y sus dependencias instaladas.
- **Rendimiento**: Para tareas extremadamente críticas en tiempo real, `cron` puede ser más eficiente.

## Instalación desde GitHub

Para instalar Pycron desde GitHub, sigue estos pasos:

 Clona el repositorio:
   ```sh
   git clone https://github.com/FelipeCupito/pycron.git
   ```

## Uso

### Archivo de Configuración

El archivo de configuración define las tareas a ejecutar y sus intervalos. Es un archivo en formato YAML que describe los comandos que Pycron debe ejecutar y con qué frecuencia.

#### Ejemplo de Archivo de Configuración

```yaml
tasks:
  - command: "echo 'Hello, World! per minute'"
    interval: "60s"
  - command: "echo 'Hello, World! per 5 minutes'"
    interval: "5m"
```

### Detalles de la Configuración

- **command**: El comando a ejecutar.
- **interval**: El intervalo en el que se debe ejecutar el comando. Puede estar en segundos (`s`), minutos (`m`) o horas (`h`).

Asegúrate de tener un archivo de configuración antes de continuar con los siguientes pasos.

### Desde la Terminal

Para ejecutar Pycron desde la terminal:

1. Instala las dependencias:
    ```sh
    cd pycron
    pip install -r requirements.txt
    ```

2. Asegúrate de tener un archivo de configuración (`config.yaml`).

3. Ejecuta el siguiente comando:
    ```sh
    python3 -m pycron.scheduler --config /ruta/a/tu/config.yaml
    ```

### Con Docker

Para construir y ejecutar el contenedor Docker:

1. Construye la imagen de Docker:
   ```sh
   docker build -t pycron .
   ```

2. Ejecuta el contenedor montando tu archivo de configuración:
   ```sh
   docker run -v $(pwd)/config.yaml:/app/config.yaml pycron
   ```

### Con Docker Compose

Un archivo `docker-compose.yml` puede verse así:

```yaml
version: '3.8'

services:
  pycron:
    image: pycron
    volumes:
      - ./config.yaml:/app/config.yaml
```

Ejecuta el siguiente comando para iniciar el servicio:

```sh
docker-compose up
```
## Extensión del Dockerfile

Para personalizar Pycron y añadir scripts y configuraciones adicionales, puedes extender el Dockerfile base. Esto es útil para adaptar Pycron a tus necesidades específicas. En este proceso, es esencial construir una imagen base de Pycron para poder crear una imagen personalizada a partir de ella.

### Pasos para Extender el Dockerfile

1. **Construcción de la Imagen Base de Pycron**

   Primero, construye la imagen base de Pycron desde el Dockerfile en la carpeta `lib/pycron`. Esto garantiza que cualquier personalización adicional se base en una imagen consistente de Pycron.

   ```sh
   cd path/to/pycron
   docker build -t pycron-image .
   ```

2. **Creación de un Dockerfile Personalizado**

   Luego, crea un Dockerfile personalizado que utilice la imagen base de Pycron y añada cualquier paquete, script o archivo de configuración adicional que necesites.

   ```Dockerfile
   FROM pycron-image

   # Agrega cualquier paquete adicional que necesites
   RUN apt-get update && apt-get install -y <tu-paquete>

   # Copia tus scripts necesarios
   COPY my_script.sh /scripts/my_script.sh

   # Copia el archivo de configuración
   COPY my_config.yaml /app/config.yaml
   ```

   - **FROM pycron-image**: Utiliza la imagen base previamente construida.
   - **RUN apt-get update && apt-get install -y <tu-paquete>**: Instala paquetes adicionales necesarios.
   - **COPY my_script.sh /scripts/my_script.sh**: Copia tus scripts personalizados al contenedor.
   - **COPY my_config.yaml /app/config.yaml**: Copia tu archivo de configuración personalizado al contenedor.

3. **Ejemplo de Archivo de Configuración (`my_config.yaml`)**

   Define las tareas que se ejecutarán periódicamente en el archivo de configuración YAML.

   ```yaml
   tasks:
     - command: "/bin/bash /scripts/my_script.sh"
       interval: "60s"
   ```
4. **Construcción de la Imagen Personalizada**
    ```sh
    docker build -t pycron-custom .
    ```
5. **Ejecución de la Imagen Personalizada**

  - #### Docker Compose
      Crea un archivo `docker-compose.yml`:
      ```yaml
      version: '3.8'

      services:
        pycron:
          build: .
          image: pycron-custom
          volumes:
            - ./config.yaml:/app/config.yaml
            - ./scripts:/scripts
      ```
      Corren el Docker Compose:
      ```sh
      docker run pycron-custom
      ```
  - #### Docker Run
    ```sh 
    docker run -v  pycron-custom
    ```


### Uso de `run.sh` para Ejecutar Pycron

Para facilitar la construcción y ejecución de los contenedores, utiliza el siguiente script `run.sh`. Este script verifica si la imagen base de Pycron está construida y la construye si es necesario, luego ejecuta Docker Compose o el Docker run.

```bash
#!/bin/bash

PYCRON_IMAGE="pycron-image"

if [[ "$(docker images -q $PYCRON_IMAGE 2> /dev/null)" == "" ]]; then
    echo "La imagen de Pycron no está construida. Construyendo..."
    docker build -t $PYCRON_IMAGE path/to/pycron-Dockerfile
fi

docker-compose up
# docker run pycron-custom
```

Para usar este script realiza los siguientes pasos:
1. Escriba el path de la carpeta donde se encuentra el Dockerfile de Pycron en la línea 7.
2. Comenete o descomente la línea 10/11 según si desea ejecutar con Docker Compose o Docker run.


## Licencia

MIT