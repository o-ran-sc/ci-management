#!/bin/sh
##############################################################################
#
#   Copyright (c) 2020 AT&T Intellectual Property.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
##############################################################################

# Installs NNG then runs a build script in the repository
# Assumes ubuntu - uses apt-get

echo "--> prescan-e2mgr-ubuntu.sh"

set -ex

sudo apt-get update && sudo apt-get install -y cmake ninja-build

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
cd E2Manager
bash ./build-e2mgr-ubuntu.sh

echo "--> prescan-e2mgr-ubuntu.sh ends"
