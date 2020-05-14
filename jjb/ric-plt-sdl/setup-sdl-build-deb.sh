#!/bin/bash
# Installs prerequisites needed to compile & test SDL code
# and build RPM/DEB packages on a Debian/Ubuntu machine.

echo "--> setup-sdl-build-deb.sh"

# Ensure we fail the job if any steps fail.
set -eux -o pipefail

# install prereqs
sudo apt-get update && sudo apt-get -q -y install \
  autoconf-archive libhiredis-dev rpm valgrind \
  libboost-filesystem-dev libboost-program-options-dev libboost-system-dev 

# generate configure script
autoreconf --install

echo "--> setup-sdl-build-deb.sh ends"
