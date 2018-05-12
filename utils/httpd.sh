#!/bin/bash
# ZoneMinder Dockerfile entrypoint script
# Written by Andrew Bauer <zonexpertconsulting@outlook.com>
#
# This script will start mysql, apache, and zoneminder services.
# It looks in common places for the files & executables it needs
# and thus should be compatible with major Linux distros.

###############
# SUBROUTINES #
###############
set -x

# Apache service management
start_http () {
    echo -n " * Starting Apache http web server service"
    # Debian requires we load the contents of envvars before we can start apache
    if [ -f /etc/apache2/envvars ]; then
        source /etc/apache2/envvars
    fi
    $HTTPBIN -k start  > /dev/null 2>&1
    RETVAL=$?
    if [ "$RETVAL" = "0" ]; then
        echo "   ...done."
    else
        echo "   ...failed!"
    fi
}


# Start Apache
start_http

