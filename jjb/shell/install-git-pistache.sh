#!/bin/bash

# O-RAN-SC
#
# Copyright (C) 2020 AT&T Intellectual Property and Nokia
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

# Installs Debian package 'pistache' to support building RPMs

echo "---> install-git-pistache.sh"

# stop on error or unbound var, and be chatty
set -eux
echo "---> install Pistache dependencies..."

export PATH=$PATH:~/.local/bin
export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu

sudo apt-get update && sudo apt-get -y install rapidjson-dev libssl-dev
python3 -m pip install meson


git clone https://github.com/pistacheio/pistache.git && cd pistache && meson setup build \
    --buildtype=release \
    -DPISTACHE_USE_SSL=true \
    -DPISTACHE_BUILD_EXAMPLES=false \
    -DPISTACHE_BUILD_TESTS=false \
    -DPISTACHE_BUILD_DOCS=false \
    --prefix="$PWD/prefix"  && \
     meson install -C build && \
     sudo cp -rf prefix/include/pistache /usr/include/pistache && \
     sudo cp prefix/lib/x86_64-linux-gnu/libpistache.so.0.0.3 $LIBRARY_PATH && \
     sudo ln -s $LIBRARY_PATH/libpistache.so.0.0.3 $LIBRARY_PATH/libpistache.so.0 && \
     sudo ln -s $LIBRARY_PATH/libpistache.so.0 $LIBRARY_PATH/libpistache.so && \
     sudo ldconfig

echo "---> install-git-pistache.sh ends"
