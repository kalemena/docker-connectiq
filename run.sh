#!/bin/bash
xhost +local:

COMMAND=${COMMAND:-/bin/bash}

echo "HOME is $HOME"
cd $HOME

# mkdir -p $HOME/.eclipse-connectiq
# -v $HOME:/media/user_home/ \
# -v $HOME/.eclipse-connectiq:/home/developer \

docker run -it --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    --privileged \
    kalemena/connectiq:latest ${COMMAND}
