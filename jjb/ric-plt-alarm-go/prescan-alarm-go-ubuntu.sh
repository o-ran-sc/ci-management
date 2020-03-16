#!/bin/bash
# Installs NNG then runs a build script in the repository
# Assumes ubuntu - uses apt-get

echo "--> prescan-alarm-go-ubuntu.sh"

set -ex

sudo apt-get install -y cmake ninja-build

# NNG repo is not frequently tagged so it's pinned to a commit hash.
# This commit repairs bug https://github.com/nanomsg/nng/issues/970
git clone https://github.com/nanomsg/nng.git
(cd nng \
    && git checkout e618abf8f3db2a94269a79c8901a51148d48fcc2 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja \
    && sudo ninja install)

# build script must start in this subdir
cd adapter
bash build_adapter_ubuntu.sh

echo "--> prescan-alarm-go-ubuntu.sh ends"
