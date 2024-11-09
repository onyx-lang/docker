FROM alpine AS build

RUN apk add gcc git musl-dev linux-headers curl

RUN curl -sSfL -o wasmer.tar.gz https://github.com/wasmerio/wasmer/releases/download/v5.0.1/wasmer-linux-musl-amd64.tar.gz
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

FROM alpine

ENV ONYX_PATH=/usr/share/onyx
ENV PATH=$PATH:$ONYX_PATH/bin

# Wasmer needs `libgcc_s`
RUN apk add libgcc

# Git is needed for the package manager, so that could probably be included by default
# RUN apk add git

COPY --from=build /usr/share/onyx /usr/share/onyx

