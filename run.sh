#!/bin/sh

# net=host for ONVIF scan success
if ! docker run -d -t -p 1080:80 --cap-add=SYS_PTRACE --publish-all=true --name zoneminger -e TZ="Europe/Moscow" --net=host zoneminder/zoneminder
then
	docker start zoneminger
fi
