# Docker Images for Onyx

This repository houses Dockerfiles for building images that are ready to
run Onyx in a production and development environments.

You can selectively build these images by manually running `docker build`.

```sh
git clone https://github.com/onyx-lang/docker onyx-docker-images
cd onyx-docker-images
export ONYX_IMAGE=nightly-ovm-alpine
docker build -t onyx:$ONYX_IMAGE -f build/$ONYX_IMAGE.Dockerfile .
```

You can also build all images using the `build_images.onyx` Onyx program.
```sh
git clone https://github.com/onyx-lang/docker onyx-docker-images
cd onyx-docker-images
onyx run build_images
```

## How images are built

These images are built by cloning the Onyx repository from Git and compiling
the compiler from source. The final output is then copied to `/usr/share/onyx`,
and the `ONYX_PATH` is set to the same folder.

