#!/bin/sh

set -x

docker stop zoneminger
docker rm zoneminger
docker rmi zoneminder/zoneminder
