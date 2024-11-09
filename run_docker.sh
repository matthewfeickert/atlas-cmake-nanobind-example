#!/bin/bash

CONTAINER_IMAGE="gitlab-registry.cern.ch/atlas/athena/analysisbase:25.2.30"

docker pull "${CONTAINER_IMAGE}"
docker run \
    --rm \
    -ti \
    -v $PWD:/workdir \
    "${CONTAINER_IMAGE}"
