#!/bin/bash

# add mono repo
apt-get -y update \
    && apt-get -y install apt-transport-https dirmngr gnupg gnupg2 gnupg1 ca-certificates \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get -y update

# install more packages
apt-get -y install wget curl dnsutils sipcalc jq libicu63 libssl1.1
apt-get -y install mono-complete
apt-get -y install --no-install-recommends --no-install-suggests bzip2 ca-certificates-mono libcurl4-openssl-dev mediainfo mono-devel mono-vbnc python sqlite3 unzip

# install sonarr
SONARR_VERSION=$(curl -sX GET https://services.sonarr.tv/v1/download/master | jq -r '.version')
curl -o /tmp/sonarr.tar.gz -L "https://download.sonarr.tv/v2/master/mono/NzbDrone.master.${SONARR_VERSION}.mono.tar.gz" \
    && mkdir -p /app/sonarr \
    && tar xf /tmp/sonarr.tar.gz -C /app/sonarr --strip-components=1 \
    && rm -f /tmp/sonarr.tar.gz \
    && echo "$(date "+%d.%m.%Y %T") Added sonarr version ${SONARR_VERSION}" >> /build_date.info

# install radarr
RADARR_RELEASE=$(curl -sX GET "https://api.github.com/repos/Radarr/Radarr/releases" | jq -r '.[0] | .tag_name')
radarr_url=$(curl -s https://api.github.com/repos/Radarr/Radarr/releases/tags/"${RADARR_RELEASE}" | jq -r '.assets[].browser_download_url' | grep linux)
curl -o /tmp/radar.tar.gz -L "${radarr_url}" \
    && mkdir -p /app/radarr \
    && tar ixzf /tmp/radar.tar.gz -C /app/radarr --strip-components=1 \
    && rm -f /tmp/radar.tar.gz \
    && echo "$(date "+%d.%m.%Y %T") Added radarr version ${RADARR_RELEASE}" >> /build_date.info

# install jackett
JACKETT_RELEASE=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | jq -r .tag_name)
curl -o /tmp/jacket.tar.gz -L "https://github.com/Jackett/Jackett/releases/download/${JACKETT_RELEASE}/Jackett.Binaries.LinuxAMDx64.tar.gz" \
    && mkdir -p /app/jackett \
    && tar xf /tmp/jacket.tar.gz -C /app/jackett --strip-components=1 \
    && chown -R root:root /app/jackett \
    && rm -f /tmp/jacket.tar.gz \
    && echo "$(date "+%d.%m.%Y %T") Added jackett version ${JACKETT_RELEASE}" >> /build_date.info

# install torsocks and privoxy
apt-get -y install torsocks privoxy \
    && mkdir -p /etc/tor \
    && rm -rf /etc/tor/* \
    && mkdir -p /etc/privoxy \
    && rm -rf /etc/privoxy/*

# install openvpn base
curl -o /install_openvpn.sh -L "https://raw.githubusercontent.com/testdasi/openvpn-client-aio-base/master/install.sh"
source /install_openvpn.sh

# install hydesa base
curl -o /install_hydesa.sh -L "https://raw.githubusercontent.com/testdasi/openvpn-hydesa-base/master/install.sh"
source /install_hydesa.sh

install hyrosa base
curl -o /install_hyrosa.sh -L "https://raw.githubusercontent.com/testdasi/openvpn-hyrosa-base/master/install.sh"
source /install_hyrosa.sh
