#!/bin/bash

## used params
# $NAMESERVER_IMAGE -n
# $master_image - m
# $worker_image - w
# $shell_image - s
# $start_shell - i (interactive)
# $VOLUME_MAP - v
# 			  - h (help)



DEBUG=0
BASEDIR=$(cd $(dirname $0); pwd)

spark_images=( "amplab/spark:0.9.0" "amplab/spark:0.9.1" "amplab/spark:1.0.0")
shark_images=( "amplab/shark:0.8.0" )
NAMESERVER_IMAGE="amplab/dnsmasq-precise"

start_shell=0
VOLUME_MAP=""

image_type="?"
image_version="?"
NUM_WORKERS=2

source $BASEDIR/start_nameserver.sh
source $BASEDIR/start_workers_containers.sh
source $BASEDIR/start_master.sh

function check_root() {
    if [[ "$USER" != "root" ]]; then
        echo "please run as: sudo $0"
        exit 1
    fi
}

function print_help() {
    echo "usage: $0 -i <image> [-w <#workers>] [-v <data_directory>] [-c]"
    echo ""
    echo "  image:    spark or shark image from:"
    echo -n "               "
    for i in ${spark_images[@]}; do
        echo -n "  $i"
    done
    echo ""
    echo -n "               "
    for i in ${shark_images[@]}; do
        echo -n "  $i"
    done
    echo ""
}

function parse_options() {
    while getopts "n:a:i:v" opt; do
        case $opt in
		n)
			NAMESERVER_IMAGE=$OPTARG
		  ;;
		  
		a) 
			COMMON_IMAGE=$OPTARG
			master_image=$COMMON_IMAGE
			worker_image=$COMMON_IMAGE
			shell_image=$COMMON_IMAGE
		  ;;
			
        i)
            start_shell=1
          ;;
    
        h)
            print_help
            exit 0
          ;;
		  
        v)
            VOLUME_MAP=$OPTARG
          ;;
        esac
    done

    if [ ! "$VOLUME_MAP" == "" ]; then
        echo "data volume chosen: $VOLUME_MAP"
        VOLUME_MAP="-v $VOLUME_MAP:/data"
    fi
}

check_root

if [[ "$#" -eq 0 ]]; then
    print_help
    exit 1
fi

parse_options $@

echo "*** Nameserver image $NAMESERVER_IMAGE ***"
start_nameserver $NAMESERVER_IMAGE
wait_for_nameserver

echo "*** Worker image $worker_image ***"
start_workers_containers $worker_image
wait_for_workers_containers

echo "*** Master image $master_image ***"
start_master $master_image
wait_for_master

#get_num_registered_workers
#echo -n "waiting for workers to register "
#until [[  "$NUM_REGISTERED_WORKERS" == "$NUM_WORKERS" ]]; do
#    echo -n "."
#    sleep 1
#    get_num_registered_workers
#done
#echo ""

#echo "***** THE CLUSTER is UP *****"

#SHELLCOMMAND="sudo $BASEDIR/start_shell.sh -i $shell_image -n $NAMESERVER $VOLUME_MAP"
#print_cluster_info "$SHELLCOMMAND"
#if [[ "$start_shell" -eq 1 ]]; then
#    SHELL_ID=$($SHELLCOMMAND | tail -n 1 | awk '{print $4}')
#    sudo docker attach $SHELL_ID
#fi
