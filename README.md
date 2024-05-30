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
- [Archivo de Configuración](#archivo-de-configuración)
- [Contribuir](#contribuir)
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

1. Clona el repositorio:
   ```sh
   git clone https://github.com/FelipeCupito/pycron.git
   cd pycron
   ```

2. Instala las dependencias:
   ```sh
   pip install -r requirements.txt
   ```

## Uso

### Archivo de Configuración

El archivo de configuración define las tareas a ejecutar y sus intervalos. Es un archivo en formato YAML, JSON o TOML que describe los comandos que Pycron debe ejecutar y con qué frecuencia.

#### Ejemplo de Archivo de Configuración (YAML)

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

1. Asegúrate de tener un archivo de configuración (`config.yaml`).
2. Ejecuta el siguiente comando:
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

### Extensión del Dockerfile

Para extender el Dockerfile y agregar tu propia configuración o scripts, sigue estos pasos:

1. Crea un `Dockerfile` personalizado:
   ```Dockerfile
   FROM pycron

   # Instala paquetes adicionales si es necesario
   RUN apt-get update && apt-get install -y <tu-paquete>

   # Copiar los scripts necesarios
   COPY my_script.sh /scripts/my_script.sh

   # Copiar el archivo de configuración
   COPY my_config.yaml /app/config.yaml
   ```

2. Archivo de configuración (`my_config.yaml`):
   ```yaml
   tasks:
     - command: "/bin/bash /scripts/my_script.sh"
       interval: "60s"
   ```

3. Construye y ejecuta la imagen:
   ```sh
   docker build -t my-pycron .
   docker run my-pycron
   ```

## Licencia

MIT
