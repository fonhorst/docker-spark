#!/bin/bash

MASTER=-1
MASTER_IP=
NUM_REGISTERED_WORKERS=0

# starts the Spark/Shark master container
function start_master() {
    echo "starting master container"
    base_dir=$(pwd)
    svisor_conf=$base_dir"/data_conf/master_supervisord.conf":"/etc/supervisor/conf.d/supervisord.conf"
    yarn_confs=$base_dir"/data_conf/master_etc_hadoop":"/usr/local/hadoop/etc/hadoop"

    if [ "$DEBUG" -gt 0 ]; then
        echo "sudo docker run -d --dns $NAMESERVER_IP -h master${DOMAINNAME} -v $svisor_conf -v $yarn_confs $VOLUME_MAP $1"
    fi
    MASTER=$(sudo docker run -d --dns $NAMESERVER_IP -h master${DOMAINNAME} -v $svisor_conf -v $yarn_confs $VOLUME_MAP $1) 

    if [ "$MASTER" = "" ]; then
        echo "error: could not start master container from image $1"
        exit 1
    fi

    echo "started master container:      $MASTER"
    sleep 3
    MASTER_IP=$(sudo docker inspect --format='{{.NetworkSettings.IPAddress}}' $MASTER)
    echo "MASTER_IP:                     $MASTER_IP"
    echo "address=\"/master/$MASTER_IP\"" >> $DNSFILE
}

function wait_for_master {
    #if [[ "$SPARK_VERSION" == "0.7.3" ]]; then
    #    query_string="INFO HttpServer: akka://sparkMaster/user/HttpServer started"
    #elif [[ "$SPARK_VERSION" == "1.0.0" ]]; then
    #    query_string="MasterWebUI: Started MasterWebUI"
    #else
    #    query_string="MasterWebUI: Started Master web UI"
    #fi
    #echo -n "waiting for master "
    #sudo docker logs $MASTER | grep "$query_string" > /dev/null
    #until [ "$?" -eq 0 ]; do
    #    echo -n "."
    #    sleep 1
    #    sudo docker logs $MASTER | grep "$query_string" > /dev/null;
    #done
    #echo ""
    #echo -n "waiting for nameserver to find master "
    #check_hostname result master "$MASTER_IP"
    #until [ "$result" -eq 0 ]; do
    #    echo -n "."
    #    sleep 1
    #    check_hostname result master "$MASTER_IP"
    #done
    #echo ""
    #sleep 3
    echo "Wait function doesn't implemented yet"
}
