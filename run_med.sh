docker run -it --rm --cpuset=0,1,2,3,4,5,6,7,8,9,10,11,12,13  -v /opt/med_data:/opt/med_data -v /opt/sequenceiq_spark/handle_med_data.sh:/opt/hmed.sh sequenceiq/supervision-spark:1.1.0 /bin/bash -c /opt/hmed.sh /opt/med_data/smaller_part 