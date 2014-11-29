FROM sequenceiq/spark:1.1.0
MAINTAINER SequenceIQ

ENV http_proxy http://proxy.ifmo.ru:3128

USER root
RUN apt-get update && apt-get install -y supervisor bc 
RUN mkdir -p /var/log/supervisor

## this commands need a proper /etc/supervisor/conf.d/supervisord.conf
## probably mounted with -v command
## also some ports may need to be exposed with --expose option of 'docker run' command 
CMD ["/usr/bin/supervisord"]
