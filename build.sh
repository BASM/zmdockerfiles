#!/bin/sh

set -ex
if [ -d "ZoneMinder" ] ; then
	( cd ZoneMinder ; git pull )
else
	git clone --recursive https://github.com/BASM/ZoneMinder
fi
docker build -t zoneminder/zoneminder -f docker/Dockerfile.x64 .
