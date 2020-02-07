#!/bin/sh
# Installs NNG then runs a build script in the repository
# Assumes ubuntu - uses apt-get

echo "--> build-e2mgr-ubuntu.sh"

set -ex

sudo apt-get install -y cmake ninja-build

# NNG repo is not frequently tagged so it's pinned to a commit hash.
# This commit repairs bug https://github.com/nanomsg/nng/issues/970
git clone https://github.com/nanomsg/nng.git
(cd nng \
    && git checkout e618abf8f3db2a94269a79c8901a51148d48fcc2 \
    && mkdir build \
    && cd build \
    && cmake3 -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja-build \
    && sudo ninja-build install)

bash E2Manager/build-e2mgr-ubuntu.sh

echo "--> build-e2mgr-ubuntu.sh ends"
