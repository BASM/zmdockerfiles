#!/bin/bash
# ZoneMinder Dockerfile entrypoint script
#
set -x

cleanup () {
    echo " * SIGTERM received. Cleaning up before exiting..."
		stop_http
    sleep 5
}


################
# MAIN PROGRAM #
################
echo
source startenv.sh

# Ensure we shutdown our services cleanly when we are told to stop
trap cleanup SIGTERM

#set localzone
source localzone.sh

#start mysql
source mysql.sh

#start web server
source httpd.sh

# Start ZoneMinder
source zoneminder.sh

# Stay in a loop to keep the container running
while :
do
    # perhaps output some stuff here or check apache & mysql are still running
    sleep 3600
done

