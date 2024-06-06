#!/bin/bash

PYCRON_IMAGE="pycron-image"

if [[ "$(docker images -q $PYCRON_IMAGE 2> /dev/null)" == "" ]]; then
    echo "La imagen de Pycron no está construida. Construyendo..."
    docker build -t $PYCRON_IMAGE path/to/pycron-Dockerfile
fi

docker-compose up
# docker run pycron-custom