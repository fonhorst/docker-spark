FROM sequenceiq/hadoop-docker:2.5.2
MAINTAINER SequenceIQ

ENV http_proxy http://proxy.ifmo.ru:3128


RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.1.0-bin-hadoop2.4.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.1.0-bin-hadoop2.4 spark
RUN mkdir /usr/local/spark/yarn-remote-client
ADD yarn-remote-client /usr/local/spark/yarn-remote-client

RUN apt-get update && apt-get install openssh-client && apt-get install openssh-server

# fix absence of sshd service 
USER root
RUN ln -s /etc/init.d/ssh /etc/init.d/sshd 

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put /usr/local/spark-1.1.0-bin-hadoop2.4/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV SPARK_JAR hdfs:///spark/spark-assembly-1.1.0-hadoop2.4.0.jar
ENV SPARK_HOME /usr/local/spark
#ENV HADOOP_USER_NAME hdfs
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin

CMD ["/etc/bootstrap.sh", "-d"]
