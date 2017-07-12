#!/bin/sh

echo "[i] Starting logstash"
sudo -u logstash /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION/bin/logstash -f /etc/$LOGSTASH_NAME/conf.d -l /var/log/$LOGSTASH_NAME/$LOGSTASH_NAME.log &
echo "[i] Starting kibana"
sudo -u kibana /opt/kibana/bin/kibana -l /var/log/$KIBANA_NAME/$KIBANA_NAME.log &
echo "[i] Starting elasticsearch"
sudo -u elasticsearch /scripts/run-es.sh
#tail -f /var/log/$LOGSTASH_NAME
