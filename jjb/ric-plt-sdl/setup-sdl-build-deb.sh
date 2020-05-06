#!/bin/bash

echo "--> setup-sdl-build-deb.sh"

# Ensure we fail the job if any steps fail.
set -eux -o pipefail

# install prereqs
sudo apt-get update && sudo apt-get -q -y install \
  libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libhiredis-dev

# generate configure script
autoreconf --install

echo "--> setup-sdl-build-deb.sh ends"
