#!/bin/bash
# ZoneMinder Dockerfile entrypoint script

###############
# SUBROUTINES #
###############
set -x

stop_http() {
	/etc/init.d/php7.0-fpm stop
	/etc/init.d/nginx stop
}

# Nginx service management
/etc/init.d/php7.0-fpm start
/etc/init.d/nginx start
