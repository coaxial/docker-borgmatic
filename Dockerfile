# install jobber
FROM golang:1.9-alpine as builder
ARG JOBBER_VERSION=1.3.2
ARG TARBALL_SHASUM=c265ee1a7076c523b44e900869b8af01817d92a5b543501e77db9277c8cf1f25
RUN apk add --no-cache make rsync grep ca-certificates openssl
WORKDIR /go_wkspc/src/github.com/dshearer
ADD https://api.github.com/repos/dshearer/jobber/tarball/v$JOBBER_VERSION v$JOBBER_VERSION
RUN echo "$TARBALL_SHASUM  v$JOBBER_VERSION" | sha256sum -cw && \
  tar xzf v$JOBBER_VERSION && rm v$JOBBER_VERSION && mv dshearer-* jobber && \
  cd jobber && \
  make check && \
  make install DESTDIR=/jobber-dist/

FROM python:3.6-alpine3.7
COPY --from=builder /jobber-dist/usr/local/libexec/jobberrunner /jobber/jobberrunner
COPY --from=builder /jobber-dist/usr/local/bin/jobber /jobber/jobber
ENV PATH /jobber:${PATH}
RUN mkdir -p /var/jobber/0

# install borg and borgmatic
RUN apk --no-cache add borgbackup

ARG BORGMATIC_VERSION=1.1.15
RUN pip3 install borgmatic==$BORGMATIC_VERSION

RUN mkdir -p /var/log/jobber &&\
  touch /var/log/jobber-runs

VOLUME /borgmatic
VOLUME /cache
VOLUME /var/log

ENV BORG_CACHE_DIR /cache

# install s6-overlay
ARG S6_OVERLAY_VERSION=1.21.2.2
ARG S6_OVERLAY_ARCH=x86
ARG SUBLIMINAL_VERSION=2.0.5
ENV S6_LOGGING_SCRIPT ""

ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-$S6_OVERLAY_ARCH.tar.gz /tmp

RUN tar xzf /tmp/s6-overlay-$S6_OVERLAY_ARCH.tar.gz -C / &&\
rm /tmp/s6-overlay-$S6_OVERLAY_ARCH.tar.gz

COPY root/ /

ENTRYPOINT ["/init"]
