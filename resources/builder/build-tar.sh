#!/bin/sh

#Update and install docker
apk add --update docker
dockerd > /dev/null 2>&1 &

#Build image, run and export as tarball 
docker build --no-cache --build-arg USER=Ubuntu -t ubuntu-20.04-custom -f resources/Dockerfile . || true
docker run --name ubuntu-20.04-custom ubuntu-20.04-custom
docker export --output='ubuntu-20.04-custom.tar.gz' ubuntu-20.04-custom