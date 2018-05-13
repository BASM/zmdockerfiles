#!/bin/bash
# ZoneMinder Dockerfile entrypoint script
#
set -x

# Check to see if this script has access to all the commands it needs
for CMD in cat grep install ln my_print_defaults mysql mysqladmin mysqld_safe sed sleep su tail usermod; do
	type $CMD &> /dev/null

	if [ $? -ne 0 ]; then
		echo
		echo "ERROR: The script cannot find the required command \"${CMD}\"."
		echo
		exit 1
	fi
done

# Look in common places for the apache executable commonly called httpd or apache2
for FILE in "/usr/sbin/httpd" "/usr/sbin/apache2"; do
	if [ -f $FILE ]; then
		HTTPBIN=$FILE
		break
	fi
done

# Look in common places for the zoneminder config file - zm.conf
for FILE in "/etc/zm.conf" "/etc/zm/zm.conf" "/usr/local/etc/zm.conf" "/usr/local/etc/zm/zm.conf"; do
	if [ -f $FILE ]; then
		ZMCONF=$FILE
		break
	fi
done

# Look in common places for the zoneminder startup perl script - zmpkg.pl
for FILE in "/usr/bin/zmpkg.pl" "/usr/local/bin/zmpkg.pl"; do
	if [ -f $FILE ]; then
		ZMPKG=$FILE
		break
	fi
done

# Look in common places for the zoneminder dB creation script - zm_create.sql
for FILE in "/usr/share/zoneminder/db/zm_create.sql" "/usr/local/share/zoneminder/db/zm_create.sql"; do
	if [ -f $FILE ]; then
		ZMCREATE=$FILE
		break
	fi
done

PHPINI="/etc/php/7.2/fpm/php.ini"
for FILE in $ZMCONF $ZMPKG $ZMCREATE $PHPINI $HTTPBIN; do 
	if [ -z $FILE ]; then
		echo
		echo "FATAL: This script was unable to determine one or more cirtical files. Cannot continue."
		echo
		echo "VARIABLE DUMP"
		echo "-------------"
		echo
		echo "Path to zm.conf: ${ZMCONF}"
		echo "Path to zmpkg.pl: ${ZMPKG}"
		echo "Path to zm_create.sql: ${ZMCREATE}"
		echo "Path to php.ini: ${PHPINI}"
		echo "Path to Apache executable: ${HTTPBIN}"
		echo
		exit 98
	fi
done

