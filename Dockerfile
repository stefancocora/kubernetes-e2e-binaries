FROM alpine:3.4

MAINTAINER stefan.cocora@gmail.com

ARG KUBERNETES_VERSION
ENV KUBERNETES_LOCATION /kubernetes/${KUBERNETES_VERSION}

RUN mkdir -p ${KUBERNETES_LOCATION}

ADD kubernetes/ ${KUBERNETES_LOCATION}
