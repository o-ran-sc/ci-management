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

# Installs RMR from PackageCloud release repo on Ubuntu
# Reads RMR version number from repo file rmr-version.yaml

echo "---> install-deb-rmr.sh"

set -eu

version_file=rmr-version.yaml
if [[ -f $version_file ]]; then
    # pipeline is less elegant than yq but that requires venv and pip install
    ver=$(grep "^version:" "$version_file" | cut -d: -f2 | xargs)
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

deb="rmr_${ver}_amd64.deb"
echo "Download RMR library ${ver} as file ${deb}"
wget -nv --content-disposition https://packagecloud.io/o-ran-sc/release/packages/debian/stretch/${deb}/download.deb
echo "Install RMR library file ${deb}"
sudo dpkg -i ${deb}
rm -f ${deb}

echo "---> install-deb-rmr.sh ends"
