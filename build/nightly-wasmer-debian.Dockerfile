FROM debian:bookworm AS build

RUN apt-get update
RUN apt-get install --yes gcc git linux-headers-amd64 curl

RUN curl -sSfL -o wasmer.tar.gz https://github.com/wasmerio/wasmer/releases/download/v5.0.1/wasmer-linux-amd64.tar.gz
RUN mkdir /root/.wasmer
RUN tar x -C /root/.wasmer -z -f wasmer.tar.gz

RUN git clone https://github.com/onyx-lang/onyx --depth 1 --single-branch /onyx
WORKDIR /onyx

ENV PATH="$PATH:/root/.wasmer/bin"
ENV ONYX_INSTALL_DIR=/usr/share/onyx
ENV ONYX_CC=gcc
ENV ONYX_ARCH="linux_x86_64"
ENV ONYX_RUNTIME_LIBRARY=wasmer

RUN sh ./build.sh compile install

FROM debian:bookworm

ENV ONYX_PATH=/usr/share/onyx
ENV PATH=$PATH:$ONYX_PATH/bin

# Git is needed for the package manager, so that could probably be included by default
# RUN apk add git

COPY --from=build /usr/share/onyx /usr/share/onyx

