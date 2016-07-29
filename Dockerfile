FROM alpine:latest
MAINTAINER Lutz Mueller <mueller.lutz@gmail.com>

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 92
ENV JAVA_VERSION_BUILD 14
ENV JAVA_PACKAGE       server-jre
ENV JAVA_SHA256_SUM    30608baff3bb3b09ea65fab603aae1c58f1381d7bb9d1b9af3dec9d499cabcc3
ENV GLIBC_VERSION      2.23-r3

RUN apk upgrade --update && \
        apk add --update libstdc++ curl ca-certificates bash && \
        for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
        apk add --allow-untrusted /tmp/*.apk && \
        rm -v /tmp/*.apk && \
        ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
        echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
        /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    mkdir -p /opt &&\
    curl -jkLH "Cookie: oraclelicense=accept-securebackup-cookie" -o java.tar.gz \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    echo "$JAVA_SHA256_SUM  java.tar.gz" | sha256sum -c - && \
    gunzip -c java.tar.gz | tar -xf - -C /opt && rm -f java.tar.gz && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
    apk del curl glibc-i18n && \
        rm -rf /opt/jdk/*src.zip \
               /opt/jdk/lib/missioncontrol \
               /opt/jdk/lib/visualvm \
               /opt/jdk/lib/*javafx* \
               /opt/jdk/jre/plugin \
               /opt/jdk/jre/bin/javaws \
               /opt/jdk/jre/bin/jjs \
               /opt/jdk/jre/bin/keytool \
               /opt/jdk/jre/bin/orbd \
               /opt/jdk/jre/bin/pack200 \
               /opt/jdk/jre/bin/policytool \
               /opt/jdk/jre/bin/rmid \
               /opt/jdk/jre/bin/rmiregistry \
               /opt/jdk/jre/bin/servertool \
               /opt/jdk/jre/bin/tnameserv \
               /opt/jdk/jre/bin/unpack200 \
               /opt/jdk/jre/lib/javaws.jar \
               /opt/jdk/jre/lib/deploy* \
               /opt/jdk/jre/lib/desktop \
               /opt/jdk/jre/lib/*javafx* \
               /opt/jdk/jre/lib/*jfx* \
               /opt/jdk/jre/lib/amd64/libdecora_sse.so \
               /opt/jdk/jre/lib/amd64/libprism_*.so \
               /opt/jdk/jre/lib/amd64/libfxplugins.so \
               /opt/jdk/jre/lib/amd64/libglass.so \
               /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
               /opt/jdk/jre/lib/amd64/libjavafx*.so \
               /opt/jdk/jre/lib/amd64/libjfx*.so \
               /opt/jdk/jre/lib/ext/jfxrt.jar \
               /opt/jdk/jre/lib/ext/nashorn.jar \
               /opt/jdk/jre/lib/oblique-fonts \
               /opt/jdk/jre/lib/plugin.jar \
               /tmp/* /var/cache/apk/* && \
    apk add ffmpeg --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    apk add rtmpdump --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    apk add aria2 --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    apk add youtube-dl --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin
