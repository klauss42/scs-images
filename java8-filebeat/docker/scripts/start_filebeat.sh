#!/bin/bash
#
# Start filebeat only if configuration file /etc/filebeat/filebeat.yml was found.
#

if [ ! -f "/etc/filebeat/filebeat.yml" ]; then
    echo "Configuration file /etc/filebeat/filebeat.yml not found, exiting"
    exit 3; # Special exit code (in allowed exitcodes of supervisod configuration file).
else
    mkdir -p /home/filebeat

    # patch filebeat config file
    cat /etc/filebeat/filebeat.yml | sed "s/LOGSTASH_HOST/$LOGSTASH_HOST/" | sed "s/LOGSTASH_PORT/$LOGSTASH_PORT/" > /etc/filebeat/filebeat.yml.tmp
    cat /etc/filebeat/filebeat.yml.tmp > /etc/filebeat/filebeat.yml
    rm /etc/filebeat/filebeat.yml.tmp

    echo "Starting filebeat using config /etc/filebeat/filebeat.yml:"
    cat /etc/filebeat/filebeat.yml

    exec /usr/local/bin/filebeat -e -c /etc/filebeat/filebeat.yml
fi
