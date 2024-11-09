FROM alpine AS build

RUN apk add gcc git musl-dev linux-headers

RUN git clone https://github.com/onyx-lang/onyx --depth 1 --single-branch /onyx
WORKDIR /onyx

ENV ONYX_INSTALL_DIR=/usr/share/onyx
ENV ONYX_CC=gcc
ENV ONYX_ARCH="linux_x86_64"
ENV ONYX_RUNTIME_LIBRARY=ovmwasm
ENV ONYX_USE_DYNCALL=1

RUN sh ./build.sh compile install

FROM alpine

ENV ONYX_PATH=/usr/share/onyx
ENV PATH=$PATH:$ONYX_PATH/bin

# Git is needed for the package manager, so that could probably be included by default
# RUN apk add git

COPY --from=build /usr/share/onyx /usr/share/onyx

