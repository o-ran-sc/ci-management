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

# Installs NNG from source and RMR from PackageCloud on CentOS7
# Reads RMR version number from repo file rmr-version.yaml

echo "---> install-rpm-nng-rmr.sh"

set -eu

echo "Install packages"
sudo yum install -y \
    cmake3 \
    ninja-build

echo "INFO: cd to tox-dir $TOX_DIR"
cd "$WORKSPACE/$TOX_DIR"

version_file=rmr-version.yaml
if [[ -f $version_file ]]; then
    # pipeline is less elegant than yq but that requires venv and pip install
    ver=$(grep "^version:" "$version_file" | cut -d: -f2 | xargs )
else
    echo "File $version_file not found."
    exit 1
fi
if [[ -z $ver ]]; then
    echo "Failed to get RMR version string from file $version_file"
    exit 1
else
    echo "RMR version string is ${ver}"
fi

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

# RPM packager adds suffix "-1" to version
rpm="rmr-${ver}-1.x86_64.rpm"
echo "Download RMR library ${ver} as file ${rpm}"
wget -nv --content-disposition https://packagecloud.io/o-ran-sc/staging/packages/el/5/${rpm}/download.rpm
echo "Install RMR library file ${rpm}"
sudo rpm -iv ${rpm}
rm -f ${rpm}

echo "---> install-rpm-nng-rmr.sh ends"
