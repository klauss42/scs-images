#!/bin/bash

if [ ! -f "/maven/service.jar" ]; then
    echo "Java Jar /maven/service.jar not found, exiting"
    exit 3; # Special exit code (in allowed exitcodes of supervisod configuration file).
else
    echo "Starting Java application /maven/service.jar"

    #probably no need to restrict meta and code cache since they rarely use more than they actually need
    #    -XX:MaxMetaspaceSize=256m \
    #    -XX:ReservedCodeCacheSize=128m \

    exec java \
        -Djava.security.egd=file:/dev/./urandom \
        -Duser.country=DE \
        -Duser.language=de \
        -Duser.timezone=Europe/Berlin \
        -XX:+UseG1GC \
        -Xmx384m \
        -jar /maven/service.jar
fi
