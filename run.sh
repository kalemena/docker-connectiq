#!/bin/bash
xhost +local:
cd $HOME
docker run -it --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    --privileged \
    kalemena/connectiq:latest /bin/bash