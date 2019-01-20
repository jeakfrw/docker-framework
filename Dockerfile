## ============================================================== ##
## Docker image for the JeakBot TS3 server query plugin framework ##
##           https://gitlab.com/fearnixxgaming/jeakbot            ##
## ============================================================== ##
FROM openjdk:8-jdk-alpine
MAINTAINER FearNixx Technik, <technik@fearnixx.de>

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache --update curl ca-certificates openssl git tar unzip bash gcc \
	&& adduser -D -h /home/container container


USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
