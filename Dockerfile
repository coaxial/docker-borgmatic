FROM python:3.6-alpine3.7

# install snooze
ARG SNOOZE_DEPS="make gcc musl-dev"
RUN apk --no-cache add curl &&\
  curl -L https://api.github.com/repos/chneukirchen/snooze/tarball/master -o /tmp/snooze.tar.gz &&\
  mkdir /tmp/snooze &&\
  tar xzf /tmp/snooze.tar.gz -C /tmp/snooze --strip 1 &&\
  cd /tmp/snooze &&\
  apk --no-cache add $SNOOZE_DEPS &&\
  make install &&\
  rm -rf /tmp/snooze &&\
  rm -rf /tmp/snooze.tar.gz &&\
  apk --no-cache del $SNOOZE_DEPS

# install borg and borgmatic
RUN apk --no-cache add borgbackup openssh-client

ARG BORGMATIC_VERSION=1.1.15
RUN pip3 install borgmatic==$BORGMATIC_VERSION

ENV BORG_CACHE_DIR /cache

# install s6-overlay
ARG S6_OVERLAY_VERSION=1.21.4.0
ARG S6_OVERLAY_ARCH=x86
ENV S6_LOGGING_SCRIPT=T

RUN apk --no-cache add curl &&\
  curl -L https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-$S6_OVERLAY_ARCH.tar.gz -o /tmp/s6-overlay.tar.gz &&\
  tar xzf /tmp/s6-overlay.tar.gz -C / &&\
  rm /tmp/s6-overlay.tar.gz &&\
  apk --no-cache del curl

COPY root/ /

VOLUME /borgmatic
VOLUME /cache
VOLUME /root/.ssh

ENTRYPOINT ["/init"]
