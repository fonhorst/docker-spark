#!/bin/bash

MASTER=-1
MASTER_IP=
NUM_REGISTERED_WORKERS=0

# starts a number of Spark/Shark workers
function start_workers_containers() {
	base_dir=$(pwd)
    svisor_conf=$base_dir"/data_conf/worker_supervisord.conf":"/etc/supervisor/conf.d/supervisord.conf"
	
    for i in `seq 1 $NUM_WORKERS`; do
        echo "starting worker container"
	hostname="worker${i}${DOMAINNAME}"
        yarn_confs=$base_dir"/data_conf/worker_etc_hadoop_${i}":"/usr/local/hadoop/etc/hadoop"
	med_data="/opt/med_data":"/opt/med_data"
        med_script="/opt/sequenceiq_spark/handle_med_data.sh":"/opt/hmed.sh"
        if [ "$DEBUG" -gt 0 ]; then
	    echo sudo docker run -d --dns $NAMESERVER_IP -h $hostname -v $svisor_conf -v $yarn_confs -v $med_data -v $med_script $VOLUME_MAP $1
        fi
	WORKER=$(sudo docker run -d --dns $NAMESERVER_IP -h $hostname -v $svisor_conf -v $yarn_confs -v $med_data -v $med_script $VOLUME_MAP $1)

        if [ "$WORKER" = "" ]; then
            echo "error: could not start worker container from image $1"
            exit 1
        fi

	echo "started worker container:  $WORKER"
	sleep 3
	WORKER_IP=$(sudo docker inspect --format='{{.NetworkSettings.IPAddress}}' $WORKER)
	echo "address=\"/$hostname/$WORKER_IP\"" >> $DNSFILE
	echo "wait for worker $hostname"
	state=$(sudo docker inspect --format='{{.State.Running}}' $WORKER)
	until [ "$state" == "true" ]; do
        echo -n "."
        sleep 1
	state=$(sudo docker inspect --format='{{.State.Running}}' $WORKER)
        echo "State: $state"
    done
    done
}

function wait_for_workers_containers {
    echo function 'wait_for_workers_containers' does nothing
}
