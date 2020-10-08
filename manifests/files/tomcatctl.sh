#!/bin/bash

if [ "$1" != "start" ] && [ "$1" != "stop" ] && [ "$1" != "status" ];
then
    echo "operation not supported"
    exit 1
fi

systemctl "$1" "tomcat-$2"