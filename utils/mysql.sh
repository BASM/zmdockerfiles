#!/bin/bash
# ZoneMinder Dockerfile entrypoint script
# Written by Andrew Bauer <zonexpertconsulting@outlook.com>
# Fix by Leonid Myravjev <asm@asm.pp.ru
#
# This script will start mysql
# It looks in common places for the files & executables it needs
# and thus should be compatible with major Linux distros.

###############
# SUBROUTINES #
###############
set -x

# Usage: get_mysql_option SECTION VARNAME DEFAULT
# result is returned in $result
# We use my_print_defaults which prints all options from multiple files,
# with the more specific ones later; hence take the last match.
get_mysql_option () {
        result=`my_print_defaults "$1" | sed -n "s/^--$2=//p" | tail -n 1`
        if [ -z "$result" ]; then
            # not found, use default
            result="$3"
        fi
}

# Return status of mysql service
mysql_running () {
    mysqladmin ping > /dev/null 2>&1
    local result="$?"
    if [ "$result" -eq "0" ]; then
        echo "1" # mysql is running
    else
        echo "0" # mysql is not running
    fi
}

# Blocks until mysql starts completely or timeout expires
mysql_timer () {
    timeout=60
    count=0
    while [ "$(mysql_running)" -eq "0" ] && [ "$count" -lt "$timeout" ]; do
        sleep 1 # Mysql has not started up completely so wait one second then check again
        count=$((count+1))
    done

    if [ "$count" -ge "$timeout" ]; then
       echo " * Warning: Mysql startup timer expired!"
    fi
}

# mysql service management
start_mysql () {
    # determine if we are running mariadb or mysql then guess pid location
    if [ $(mysql --version |grep -ci mariadb) -ge "1" ]; then
        default_pidfile="/var/run/mariadb/mariadb.pid"
    else
        default_pidfile="/var/run/mysqld/mysqld.pid"
    fi

    # verify our guessed pid file location is right
    get_mysql_option mysqld_safe pid-file $default_pidfile
    mypidfile=$result
    mypidfolder=${mypidfile%/*}

    # Start mysql only if it is not already running
    if [ "$(mysql_running)" -eq "0" ]; then
        echo -n " * Starting MySQL database server service"
        test -e $mypidfolder || install -m 755 -o mysql -g root -d $mypidfolder
        mysqld_safe --user=mysql --timezone="$TZ" > /dev/null 2>&1 &
        RETVAL=$?
        if [ "$RETVAL" = "0" ]; then
            echo "   ...done."
            mysql_timer # Now wait until mysql finishes its startup
        else
            echo "   ...failed!"
        fi
    else
        echo " * MySQL database server already running."
    fi

    mysqlpid=`cat "$mypidfile" 2>/dev/null`    
}


cleanup () {
    echo " * SIGTERM received. Cleaning up before exiting..."
    kill $mysqlpid > /dev/null 2>&1
    sleep 5
}

################
# MAIN PROGRAM #
################

# Configure then start Mysql
if [ -n "$MYSQL_SERVER" ] && [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ] && [ -n "$MYSQL_DB" ]; then
    sed -i -e "s/ZM_DB_NAME=zm/ZM_DB_NAME=$MYSQL_USER/g" $ZMCONF
    sed -i -e "s/ZM_DB_USER=zmuser/ZM_DB_USER=$MYSQL_USER/g" $ZMCONF
    sed -i -e "s/ZM_DB_PASS=zm/ZM_DB_PASS=$MYSQL_PASS/g" $ZMCONF
    sed -i -e "s/ZM_DB_HOST=localhost/ZM_DB_HOST=$MYSQL_SERVER/g" $ZMCONF
    start_mysql
else
    usermod -d /var/lib/mysql/ mysql
    start_mysql
    mysql -u root < $ZMCREATE
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'zmuser'@'localhost' IDENTIFIED BY 'zmpass';"
fi

# Ensure we shutdown our services cleanly when we are told to stop
trap cleanup SIGTERM


