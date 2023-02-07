## ============================================================== ##
## Docker image for the JeakBot TS3 server query plugin framework ##
##           https://github.com/jeakfrw/core-framework            ##
##           https://github.com/jeakfrw/pterodactyl-image         ##
## ============================================================== ##
FROM openjdk:11-jdk-slim
MAINTAINER FearNixx Technik, <technik@fearnixx.de>

RUN apt update \
	&& apt -y upgrade \
	&& apt install -y curl ca-certificates openssl git tar unzip bash gcc libopus-dev python3 python3-pip \
	&& update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
	&& useradd -d /home/container -m container
	
USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

COPY jeakbot-1.2.2-SNAPSHOT.tar.gz /opt/jeakbot.tar.gz

CMD ["/bin/bash", "/entrypoint.sh"]
