FROM ghcr.io/linuxserver/baseimage-alpine:3.13 AS buildstage

ENV OPENTRACING_CPP_VERSION 1.6.0

RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev \
  g++ \
  git \
  cmake \
  apache2-utils \
  git \
  libressl3.1-libssl \
  logrotate \
  nano \
  nginx

RUN wget "https://github.com/opentracing/opentracing-cpp/archive/v${OPENTRACING_CPP_VERSION}.tar.gz" -O opentracing-cpp.tar.gz && \
  mkdir -p opentracing-cpp/.build && \
  tar zxvf opentracing-cpp.tar.gz -C ./opentracing-cpp/ --strip-components=1 && \
  cd opentracing-cpp/.build && \
  cmake .. && \
  make && \
  make install

FROM scratch

COPY --from=buildstage /usr/local/lib/ /opentracing/
