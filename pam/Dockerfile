FROM ubuntu:14.04
MAINTAINER SequenceIQ

ENV http_proxy http://proxy.ifmo.ru:3128

#Setup build environment for libpam
RUN apt-get update && apt-get -y build-dep pam

#Rebuild and istall libpam with --disable-audit option
RUN export CONFIGURE_OPTS=--disable-audit && cd /root && apt-get -b source pam && dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

