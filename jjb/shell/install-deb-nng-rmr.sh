#!/bin/bash

# O-RAN-SC
#
# Copyright (C) 2019 AT&T Intellectual Property and Nokia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Installs NNG from source and RMR from PackageCloud on Ubuntu18.04

echo "---> install-deb-nng-rmr.sh"

set -eu

echo "Install packages"
sudo apt-get update && \
    sudo apt-get install -y \
    cmake \
    ninja-build

# NNG repo is not frequently tagged so it's pinned to a commit hash.
# This commit provides fix to the proxy-reconnect
# bug that we identified:  https://github.com/nanomsg/nng/issues/970
echo "Clone and build NNG"
git clone https://github.com/nanomsg/nng.git
(cd nng \
    && git checkout e618abf8f3db2a94269a79c8901a51148d48fcc2 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja \
    && sudo ninja install)

ver="1.6.0"
echo "Download RMR library ${ver}"
wget --content-disposition https://packagecloud.io/o-ran-sc/staging/packages/debian/stretch/rmr_${ver}_amd64.deb/download.deb
echo "Install RMR library ${ver}"
sudo dpkg -i rmr_${ver}_amd64.deb
