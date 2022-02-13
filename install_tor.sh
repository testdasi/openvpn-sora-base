#!/bin/bash

# install jackett
JACKETT_RELEASE=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | jq -r .tag_name)
curl -o /tmp/jacket.tar.gz -L "https://github.com/Jackett/Jackett/releases/download/${JACKETT_RELEASE}/Jackett.Binaries.LinuxAMDx64.tar.gz" \
    && mkdir -p /app/jackett \
    && tar xf /tmp/jacket.tar.gz -C /app/jackett --strip-components=1 \
    && chown -R root:root /app/jackett \
    && rm -f /tmp/jacket.tar.gz \
    && echo "$(date "+%d.%m.%Y %T") Added jackett version ${JACKETT_RELEASE}" >> /build_date.info

# install rtorrent with screen (required to send it to background)
apt-get -y update \
    && apt-get -y install rtorrent screen
    
# install additional packages to build flood
# apt-get -y install build-essential git
# install nodejs to run flood
curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get -y install -y nodejs
# New fork of flood at https://github.com/jesec/flood
npm install --global flood

# clean up building packages (and reinstall procps which is somehow removed by autoremove)
# apt-get -y remove build-essential git \
apt-get -y autoremove \
#    && apt-get -y autoremove \
    && apt-get -y install procps
