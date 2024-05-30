# Pycron

Pycron es una herramienta simple basada en Python para ejecutar tareas periódicas definidas por el usuario. Es especialmente útil en entornos Docker donde `cron` puede ser difícil de manejar.

## Instalación

Para construir y ejecutar el contenedor Docker:

```sh
docker build -t pycron .
docker run -v $(pwd)/examples/config.yaml:/app/config.yaml pycron
