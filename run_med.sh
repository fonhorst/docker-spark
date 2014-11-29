docker run -it --rm --cpuset=0,1,8  -v /opt/med_data:/opt/med_data -v /opt/sequenceiq_spark/handle_med_data.sh:/opt/hmed.sh sequenceiq/supervision-spark:1.1.0 /opt/hmed.sh /opt/med_data/smaller_part 
