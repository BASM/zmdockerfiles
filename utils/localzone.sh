#!/bin/bash
set -x

if [ -z "$TZ" ]; then
    TZ="UTC"
fi
echo "date.timezone = $TZ" >> $PHPINI
if [ -L /etc/localtime ]; then
    ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime
fi
if [ -f /etc/timezone ]; then
    echo "$TZ" > /etc/timezone
fi
