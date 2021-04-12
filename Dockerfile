ARG FRM='mono:latest'
ARG TAG='latest'

FROM ${FRM}
ARG FRM
ARG TAG
ARG TARGETPLATFORM

# Install basic packages
RUN apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get -y install sudo bash nano procps tini \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Install script
COPY ./install.sh /
RUN /bin/bash /install.sh \
    && rm -f /install*.sh

RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info
