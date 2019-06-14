## ============================================================== ##
## Docker image for the JeakBot TS3 server query plugin framework ##
##           https://github.com/jeakfrw/core-framework            ##
##           https://github.com/jeakfrw/pterodactyl-image         ##
## ============================================================== ##
FROM openjdk:11-jdk-slim
MAINTAINER FearNixx Technik, <technik@fearnixx.de>

RUN apt update \
	&& apt -y upgrade \
	&& apt install -y curl ca-certificates openssl git tar unzip bash gcc \
	&& adduser -D -h /home/container container


USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
