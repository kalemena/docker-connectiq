#!/bin/bash
xhost +local:

CIQ_WORKSPACE=${CIQ_WORKSPACE:-`pwd`/eclipse-workspace}
EXAMPLES_FOLDER=${EXAMPLES_FOLDER:-`pwd`/examples}
COMMAND=${COMMAND:-/bin/bash}

MAP_UID=${UID:-`id -u`}
MAP_GID=${GID:-`id -g`}

echo "CIQ_WORKSPACE is $CIQ_WORKSPACE"
echo "EXAMPLES_FOLDER is $EXAMPLES_FOLDER"

if [ -f ${CIQ_WORKSPACE}/developer_key.der ]; then
    echo "Certificate keys already created"
else
    echo "Generating Certificate keys"
    openssl genrsa -out ${CIQ_WORKSPACE}/developer_key.pem 4096
    openssl pkcs8 -topk8 -inform PEM -outform DER -in ${CIQ_WORKSPACE}/developer_key.pem -out ${CIQ_WORKSPACE}/developer_key.der -nocrypt
fi

docker run -it --rm \
    -v $CIQ_WORKSPACE:/home/developer/eclipse-workspace \
    -v $EXAMPLES_FOLDER:/home/developer/examples \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    -u $MAP_UID:$MAP_GID \
    --privileged \
    kalemena/connectiq:latest ${COMMAND}
