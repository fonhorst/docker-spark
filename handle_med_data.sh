#!/bin/bash

## used params
# path
# -d option - parse directory or execute all

FILES_LIST=0
DATA_PATH=$1


function parse_options() {
    while getopts ":d" opt; do
        case $opt in
		d)
			FILES_LIST=1
			DATA_PATH=$2
		 ;;
        esac
    done
}


parse_options $@

if [ "$FILES_LIST" = 1 ];
then
	FILES=$(ls -d -1 "$DATA_PATH"/*) 	
else
	FILES=($DATA_PATH)
fi

START=$(date +%s.%N)

for file in $FILES; do
	java -jar /mnt/win_share_2/Melnik/ECG_analise.jar $file 12 16 
done

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)

echo $DIFF





