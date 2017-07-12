#!/bin/bash

dumpFile() {
	echo "-----------------------------------------------------------------------------"
	echo ">>>> $1 start"
	cat $1
	echo ">>>> $1 end"
	echo " "
}

source /scripts/vars.sh

/scripts/templater.sh /templates/start_service.sh.template -s > /scripts/start_service.sh
dumpFile /scripts/start_service.sh

##
## filebeat configuration
##
rm -f /etc/filebeat/filebeat.yml
if [[ "${ENABLE_FILEBEAT}" == "true" ]]; then
	echo "-----------------------------------------------------------------------------"
    echo "Enable Filebeat"
    /scripts/templater.sh /templates/filebeat/filebeat.yml.template -s > /etc/filebeat/filebeat.yml
    dumpFile /etc/filebeat/filebeat.yml

    /scripts/templater.sh /templates/filebeat/supervisor_service.ini.template -s > /etc/supervisor.d/supervisor_service.ini
    dumpFile /etc/supervisor.d/supervisor_service.ini
else
	echo "-----------------------------------------------------------------------------"
    echo "Disabling Filebeat"
    cp /templates/stdout/supervisor_service.ini /etc/supervisor.d/supervisor_service.ini
    dumpFile /etc/supervisor.d/supervisor_service.ini
fi

# start all the services
exec /usr/bin/supervisord -n
