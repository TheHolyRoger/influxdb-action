echo "Setting up Influx"

if [ "$INFLUXDB_START" = "true" ]
then
    if [ "$INFLUXDB_VERSION" = "v1" ] || [[ $INFLUXDB_VERSION = 1* ]];
    then
        sudo influxd &
    else
        influxd --http-bind-address :8086 --reporting-disabled > /dev/null 2>&1 &
    fi
    echo "Waiting for influx to be up."
    FINAL_WAIT_TIME=0
    until [ $NEXT_WAIT_TIME -eq 20 ] | curl -s http://localhost:8086/health; do sleep $(( NEXT_WAIT_TIME++ )); done
    echo "Influx Running."
    if [ "$INFLUXDB_VERSION" = "v1" ] || [[ $INFLUXDB_VERSION = 1* ]];
    then
        exit 0
    else
        sudo influx setup --host http://localhost:8086 -f \
            -o $INFLUXDB_ORG \
            -u $INFLUXDB_USER \
            -p $INFLUXDB_PASSWORD \
            -b $INFLUXDB_BUCKET
    fi
fi