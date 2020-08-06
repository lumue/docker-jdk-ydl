FROM debian:experimental
MAINTAINER Lutz Mueller <mueller.lutz@gmail.com>

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 92
ENV JAVA_VERSION_BUILD 14
ENV JAVA_PACKAGE       server-jre
ENV JAVA_SHA256_SUM    30608baff3bb3b09ea65fab603aae1c58f1381d7bb9d1b9af3dec9d499cabcc3

RUN apt-get -y update && \
    apt-get -y install curl && \
    apt-get -y install python3 && \
    mkdir -p /opt &&\
    curl -jkLH "Cookie: oraclelicense=accept-securebackup-cookie" -o java.tar.gz \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    echo "$JAVA_SHA256_SUM  java.tar.gz" | sha256sum -c - && \
    gunzip -c java.tar.gz | tar -xf - -C /opt && rm -f java.tar.gz && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
    rm -rf /opt/jdk/*src.zip \
         /opt/jdk/lib/missioncontrol \
         /opt/jdk/lib/visualvm \
         /opt/jdk/lib/*javafx* \
         /opt/jdk/jre/lib/plugin.jar \
         /opt/jdk/jre/lib/ext/jfxrt.jar \
         /opt/jdk/jre/bin/javaws \
         /opt/jdk/jre/lib/javaws.jar \
         /opt/jdk/jre/lib/desktop \
         /opt/jdk/jre/plugin \
         /opt/jdk/jre/lib/deploy* \
         /opt/jdk/jre/lib/*javafx* \
         /opt/jdk/jre/lib/*jfx* \
         /opt/jdk/jre/lib/amd64/libdecora_sse.so \
         /opt/jdk/jre/lib/amd64/libprism_*.so \
         /opt/jdk/jre/lib/amd64/libfxplugins.so \
         /opt/jdk/jre/lib/amd64/libglass.so \
         /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
         /opt/jdk/jre/lib/amd64/libjavafx*.so \
         /opt/jdk/jre/lib/amd64/libjfx*.so && \
    apt-get -y install aptitude && \
    apt-get -y --allow-remove-essential purge xserver-xorg-video-* && \
    apt-get -y --allow-remove-essential purge $(aptitude search '~i!~M!~prequired!~pimportant!~R~prequired!~R~R~prequired!~R~pimportant!~R~R~pimportant!busybox!grub!initramfs-tools' | awk '{print $2}') && \
    apt-get -y --allow-remove-essential purge aptitude && \
    apt-get -y install ffmpeg && \
    apt-get -y install rtmpdump && \
    apt-get -y install aria2 && \
    apt-get -y install youtube-dl && \
    apt-get -y --allow-remove-essential autoremove && \
    apt-get -y clean && \
    rm -rf /var/cache/*


# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin
