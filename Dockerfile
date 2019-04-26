FROM ubuntu:18.04

MAINTAINER Kalemena

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Connect IQ SDK" \
      org.label-schema.description="Kalemena Connect IQ SDK" \
      org.label-schema.url="private" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kalemena/docker-connectiq" \
      org.label-schema.vendor="Kalemena" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENV LANG C.UTF-8

# Compiler tools
RUN apt-get update -y; \
    apt-get install -qqy openjdk-8-jdk; \
    apt-get install -qqy unzip wget git ssh tar gzip ca-certificates; \
    apt-get clean; \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN cd /opt; \
    wget -q https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${VERSION}.zip -O ciq.zip; \
    unzip ciq.zip -d ciq; \
    rm -f ciq.zip

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${PATH}:${CIQ_HOME}

CMD [ "/bin/bash" ]