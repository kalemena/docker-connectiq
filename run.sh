#!/bin/bash
xhost +local:

CIQ_WORKSPACE=${CIQ_WORKSPACE:-`pwd`}
COMMAND=${COMMAND:-/bin/bash}

MAP_UID=${UID:-`id -u`}
MAP_GID=${GID:-`id -g`}

echo "HOME is $HOME"

docker run -it --rm \
    -v $CIQ_WORKSPACE:/workspace \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    -u $MAP_UID:$MAP_GID \
    --privileged \
    kalemena/connectiq:latest ${COMMAND}
