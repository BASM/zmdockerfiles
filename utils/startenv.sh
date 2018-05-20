#!/bin/bash
# ZoneMinder Dockerfile entrypoint script
#
set -x

# Check to see if this script has access to all the commands it needs
for CMD in cat grep install ln mysql mysqladmin sed sleep su tail usermod; do
	type $CMD &> /dev/null

	if [ $? -ne 0 ]; then
		echo
		echo "ERROR: The script cannot find the required command \"${CMD}\"."
		echo
		exit 1
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
for FILE in $ZMCONF $ZMPKG $ZMCREATE $PHPINI; do 
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
		echo
		exit 98
	fi
done

