#!/bin/bash

until $(curl --output /dev/null --silent --fail http://admin:admin@localhost:80); do
    printf '.'
    sleep 5
done

curl 'http://admin:admin@localhost:80/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary '{"name":"Local Graphite","type":"graphite","url":"http://localhost:8000","access":"proxy","isDefault":true}'
