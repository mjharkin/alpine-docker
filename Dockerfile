ARG ALPINE_VER=3.7
FROM alpine:$ALPINE_VER
MAINTAINER Mark Harkin <mjha@nationalbanken.dk>

ARG DOCKER_VER=17.09.0-ce
ENV DOCKER_CHANNEL stable
ENV DOCKER_VER $DOCKER_VER
ENV DOCKER_ARCH x86_64

# Docker user 
RUN addgroup -S docker \
 && adduser -S -g docker docker

 
RUN apk add --no-cache --virtual .fetch-deps wget tar ca-certificates \
  && wget "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${DOCKER_ARCH}/docker-${DOCKER_VER}.tgz" \
  && tar --extract --file docker-${DOCKER_VER}.tgz --strip-components 1 --directory /tmp docker \
  && mv /tmp/docker /usr/bin \
  && rm /tmp/* \
  && rm docker-${DOCKER_VER}.tgz \
  && apk del .fetch-deps  \
  && chown -R docker:docker /usr/bin/docker \
  && chmod 770 /usr/bin/docker 

USER docker

ENTRYPOINT ["docker"]
CMD ["info"]

