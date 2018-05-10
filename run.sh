#!/bin/sh

set -x
docker run -d -t -p 1080:80 --shm-size="512m" --name zoneminger zoneminder/zoneminder
