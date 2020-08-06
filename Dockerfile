FROM debian:experimental
MAINTAINER Lutz Mueller <mueller.lutz@gmail.com>

RUN apt-get -y update && \
    apt-get -y install curl && \
    apt-get -y install python3 && \
    mkdir -p /opt &&\
    apt-get -y install aptitude && \
    apt-get -y --allow-remove-essential purge xserver-xorg-video-* && \
    apt-get -y --allow-remove-essential purge $(aptitude search '~i!~M!~prequired!~pimportant!~R~prequired!~R~R~prequired!~R~pimportant!~R~R~pimportant!busybox!grub!initramfs-tools' | awk '{print $2}') && \
    apt-get -y --allow-remove-essential purge aptitude && \
    apt-get -y install ffmpeg && \
    apt-get -y install rtmpdump && \
    apt-get -y install aria2 && \
    apt-get -y install openjdk-11-jdk-headless && \
    apt-get -y install youtube-dl && \
    apt-get -y --allow-remove-essential autoremove && \
    apt-get -y clean && \
    rm -rf /var/cache/*


# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin
