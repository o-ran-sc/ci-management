#!/bin/bash
# Installs NNG then run a build script in the repository
# Assumes ubuntu - uses apt-get

echo "--> build-alarm-go-ubuntu.sh"

echo "Install packages"
sudo apt-get install -y cmake ninja-build

# NNG repo is not frequently tagged so it's pinned to a commit hash.
# This commit provides fix to the proxy-reconnect
# bug that we identified:  https://github.com/nanomsg/nng/issues/970
echo "Clone and build NNG"
git clone https://github.com/nanomsg/nng.git
(cd nng \
    && git checkout e618abf8f3db2a94269a79c8901a51148d48fcc2 \
    && mkdir build \
    && cd build \
    && cmake3 -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja-build \
    && sudo ninja-build install)

cmd="./adapter/build_adapter.sh"
echo "INFO: invoking build script: $cmd"
$cmd

echo "--> build-alarm-go-ubuntu.sh ends"
