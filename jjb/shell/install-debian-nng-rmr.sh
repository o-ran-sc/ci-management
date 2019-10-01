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

# Debian install script for NNG and RMR from source 
# Reads RMR branch name from repo file rmr-version.yaml
# in directory $TOX_DIR

echo "---> install-debian-nng-rmr.sh"

set -eu

echo "Install packages"
sudo apt-get update && \
    sudo apt-get install -y \
    cmake \
    ninja-build

echo "INFO: cd to tox-dir $TOX_DIR"
cd "$WORKSPACE/$TOX_DIR"

version_file=rmr-version.yaml
if [[ -f $version_file ]]; then
    # pipeline is less elegant than yq but that requires venv and pip install
    branch=$(grep "^branch:" "$version_file" | cut -d: -f2 | xargs )
else
    echo "File $version_file not found."
    exit 1
fi
if [[ -z $branch ]]; then
    echo "Failed to get RMR branch from file $version_file"
    exit 1
else
    echo "RMR branch is ${branch}"
fi

cd /tmp
git clone --branch ${branch} https://gerrit.o-ran-sc.org/r/ric-plt/lib/rmr \
    && cd rmr \
    && mkdir build \
    && cd build \
    && cmake .. -DPACK_EXTERNALS=1 \
    && sudo make install

echo "---> install-debian-nng-rmr.sh ends"
