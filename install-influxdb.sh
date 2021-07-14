cd /tmp
if [ "$INFLUXDB_VERSION" = "latest" ];
then
  export INFLUXDB_VERSION=$(curl --silent "https://api.github.com/repos/influxdata/influxdb/releases/latest" | jq -r .tag_name | sed -e 's/v//g')
  export INFLUXDB_DOWNLOAD_PATH="https://dl.influxdata.com/influxdb/releases"
elif [ "$INFLUXDB_VERSION" = "nightly" ];
then
  export INFLUXDB_DOWNLOAD_PATH="https://dl.influxdata.com/platform/nightlies"
else
  export INFLUXDB_DOWNLOAD_PATH="https://dl.influxdata.com/influxdb/releases"
fi

echo "Influx Installing."
if [ "$INFLUXDB_VERSION" = "v1" ];
then
  wget -q $INFLUXDB_DOWNLOAD_PATH/influxdb_1.8.6_amd64.deb
  sudo dpkg -i influxdb_1.8.6_amd64.deb
  sudo rm -r influxdb_1.8.6_amd64.deb
  cd -
elif [[ $INFLUXDB_VERSION = 1* ]];
then
  wget -q $INFLUXDB_DOWNLOAD_PATH/influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz
  tar xvfz influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz
  sudo cp influxdb-${INFLUXDB_VERSION}-1/usr/bin/{influx,influxd} /usr/local/bin/
  sudo mkdir -p /etc/influxdb
  sudo cp influxdb-${INFLUXDB_VERSION}-1/etc/influxdb/influxdb.conf /etc/influxdb/
  rm -r influxdb-${INFLUXDB_VERSION}-1/
  cd -
else
  wget -q $INFLUXDB_DOWNLOAD_PATH/influxdb2-${INFLUXDB_VERSION}-linux-amd64.tar.gz
  tar xvfz influxdb2-${INFLUXDB_VERSION}-linux-amd64.tar.gz
  sudo cp influxdb2-${INFLUXDB_VERSION}-linux-amd64/{influx,influxd} /usr/local/bin/
  rm -r influxdb2-${INFLUXDB_VERSION}-linux-amd64/
  cd -
fi

echo "Influx Installed."

exit 0
