#!/bin/sh

if ! docker run -d -t -p 1080:80 --publish-all=true --name zoneminger -e TZ="Europe/Moscow" zoneminder/zoneminder
then
	docker start zoneminger
fi
