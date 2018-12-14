#!/usr/bin/docker-builder
# IMAGE: sergioromcar/debian:jessie2

FROM debian:jessie
MAINTAINER Sergio Romero Carrizosa <sergioromcar@hotmail.es>

RUN (echo "deb http://http.debian.net/debian/ jessie main contrib non-free" > /etc/apt/sources.list) && \
(echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list) && \
(echo "deb http://http.debian.net/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list) && \
(echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list) && \
echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq --no-install-recommends && \
DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends wget zip nano curl && \
DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends --reinstall procps && \
DEBIAN_FRONTEND=noninteractive apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99-ignore-valid-until
RUN echo 'APT::Get::AllowUnauthenticated 1 ;' > /etc/apt/apt.conf.d/99-unauthenticated
