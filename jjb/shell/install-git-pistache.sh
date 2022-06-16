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

# Installs Debian package 'alien' to support building RPMs

echo "---> install-git-pistache.sh"

# stop on error or unbound var, and be chatty
set -eux
echo "---> install Pistache dependencies..."
sudo apt-get update && apt-get install rapidjson-dev meson libssl-dev

echo "---> install Pistache library.."
git clone https://github.com/pistacheio/pistache.git && cd pistache && meson setup build \
    --buildtype=release \
    -DPISTACHE_USE_SSL=true \
    -DPISTACHE_BUILD_EXAMPLES=false \
    -DPISTACHE_BUILD_TESTS=false \
    -DPISTACHE_BUILD_DOCS=false \
    --prefix="$PWD/prefix" \
     && meson install -C build && \
     cp -rf prefix/include/pistache /usr/local/include/ && \
     cp -rf prefix/lib/x86_64-linux-gnu/* /usr/lib/x86_64-linux-gnu/ && \
     cd .. && rm -rf pistache 

echo "---> install-git-pistache.sh ends"
