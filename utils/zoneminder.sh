

# ZoneMinder service management
start_zoneminder () {
    echo -n " * Starting ZoneMinder video surveillance recorder"
    $ZMPKG start > /dev/null 2>&1
    RETVAL=$?
    if [ "$RETVAL" = "0" ]; then
        echo "   ...done."
    else
        echo "   ...failed!"
    fi
}

start_zoneminder
