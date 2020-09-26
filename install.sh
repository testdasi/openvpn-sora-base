#!/bin/bash

# install more packages
apt-get -y update \
    && apt-get -y install apt-transport-https \
    && apt-get -y install --no-install-recommends --no-install-suggests wget curl unzip dnsutils sipcalc mediainfo sqlite3 jq gnupg gnupg2 gnupg1

# install openvpn with nftables
apt-get install -y openvpn
apt-get install -y nftables

# install stubby and clean config
apt-get -y install stubby \
    && mkdir -p /etc/stubby \
    && rm -rf /etc/stubby/*

# install dante server and clean config
apt-get -y install dante-server \
    && rm -f /etc/danted.conf

# install tinyproxy and clean config
apt-get -y install tinyproxy \
    && mkdir -p /etc/tinyproxy \
    && rm -rf /etc/tinyproxy/*

# install sonarr
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493 \
    && echo "deb http://apt.sonarr.tv/ master main" | tee /etc/apt/sources.list.d/sonarr.list
apt-get -y install nzbdrone

# install radarr
cd /tmp \
    && curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) \
    && tar -xvzf Radarr.develop.*.linux.tar.gz \
    && rm -f Radarr.develop.*.linux.tar.gz \
    && mv Radarr /opt 
