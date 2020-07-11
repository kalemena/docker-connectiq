FROM ubuntu:18.04

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG ADDITIONAL_PACKAGES
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
RUN apt-get update -y && \
    apt-get install -qqy openjdk-8-jdk && \
    apt-get install -qqy unzip wget git ssh tar gzip ca-certificates libusb-1.0 libpng16-16 libgtk2.0-0 libwebkitgtk-1.0-0 libwebkitgtk-3.0-0 && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Check at https://developer.garmin.com/downloads/connect-iq/sdks/sdks.xml
RUN echo "Downloading Connect IQ SDK: ${VERSION}" && \
    cd /opt && \
    wget -q https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${VERSION}.zip -O ciq.zip && \
    unzip ciq.zip -d ciq && \
    rm -f ciq.zip

# Fix missing libpng12 (monkeydo)
RUN ln -s /usr/lib/x86_64-linux-gnu/libpng16.so.16 /usr/lib/x86_64-linux-gnu/libpng12.so.0

# Install Eclipse IDE
ENV ECLIPSE_DOWNLOAD_URL=http://ftp.fau.de/eclipse/technology/epp/downloads/release/2019-12/R/eclipse-java-2019-12-R-linux-gtk-x86_64.tar.gz
RUN wget ${ECLIPSE_DOWNLOAD_URL} -O /tmp/eclipse.tar.gz -q && \
    echo "Installing eclipse JavaEE ${ECLIPSE_DOWNLOAD_URL}" && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz
# Eclipse IDE plugins
RUN cd /opt/eclipse && \
    ./eclipse -clean -application org.eclipse.equinox.p2.director -noSplash \
              -repository https://developer.garmin.com/downloads/connect-iq/eclipse/ \
              -installIU connectiq.feature.ide.feature.group/ && \
    ./eclipse -clean -application org.eclipse.equinox.p2.director -noSplash \
              -repository https://developer.garmin.com/downloads/connect-iq/eclipse/ \
              -installIU connectiq.feature.sdk.feature.group/

# Few prefs
ADD [ "eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/IQ_IDE.prefs", "/home/developer/eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/IQ_IDE.prefs" ]
ADD [ "org.eclipse.ui.ide.prefs", "/opt/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs" ]

# USER developer as 1000
RUN mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    chown developer:developer -R /home/developer && \
    chown developer:developer -R /opt

USER developer
ENV HOME /home/developer
WORKDIR /home/developer

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${PATH}:${CIQ_HOME}:/opt/eclipse

# CMD [ "/opt/eclipse/eclipse" ]
CMD [ "/bin/bash" ]