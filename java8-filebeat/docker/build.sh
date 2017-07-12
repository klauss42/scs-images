#!/bin/bash

#set -x
set -e

cp -r /build/scripts /scripts
chmod +x /scripts/*
cp -r /build/templates /templates

cp /build/bin/filebeat /usr/local/bin/
chmod +x /usr/local/bin/filebeat

mkdir -p /var/log/supervisor
mkdir -p /home/filebeat
mkdir -p /etc/filebeat
mkdir -p /etc/supervisor.d/

cp /build/templates/logstash-beats.crt /etc/filebeat
cp /build/templates/supervisor_*.ini /etc/supervisor.d/

/scripts/templater.sh /templates/filebeat/filebeat.yml.template -s > /etc/filebeat/filebeat.yml

rm -rf /var/cache/apk/*
