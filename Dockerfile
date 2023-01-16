# Download base image ubuntu 22.04
FROM ubuntu:22.04

LABEL com.centurylinklabs.watchtower.enable="false"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update
RUN apt upgrade -y

# Install dependencies
RUN apt-get -y install build-essential libffi-dev perl zlib1g-dev wget ca-certificates

# Add default user (with UID 35505 and GID 35505)
RUN groupadd -r duo -g 35505 && useradd --no-log-init -r -g duo -u 35505 duo

# Install duoauthproxy itself
RUN wget -O /tmp/duoauthproxy-latest-src.tgz https://dl.duosecurity.com/duoauthproxy-latest-src.tgz
RUN tar -zxf /tmp/duoauthproxy-latest-src.tgz -C /tmp
RUN mv /tmp/duoauthproxy-*-src /tmp/duoauthproxy-src
RUN cd /tmp/duoauthproxy-src && make
RUN cd /tmp/duoauthproxy-src/duoauthproxy-build && ./install --install-dir /opt/duoauthproxy --service-user duo --log-group duo --create-init-script no --enable-selinux no

# Clean up
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean

# Volume configuration
VOLUME ["/opt/duoauthproxy/conf", "/opt/duoauthproxy/log"]

USER duo:duo
CMD ["/opt/duoauthproxy/bin/authproxy", "--logging-insecure"]

# Expose Ports for the Application 
EXPOSE 389
EXPOSE 636