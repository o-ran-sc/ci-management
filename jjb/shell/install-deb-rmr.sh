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

# Installs RMR headers and shared-object libraries from PackageCloud
# on a Debian; does NOT install or assume NNG.
# Reads RMR version number from repo file rmr-version.yaml like this:
#   ---
#   repo: staging             (this entry is optional)
#   version: 3.8.2            (this entry is required)

echo "---> install-deb-rmr.sh"
# stop on error or unbound var, and be chatty
set -eux

version_file=rmr-version.yaml
if [[ -f $version_file ]]; then
    # pipeline is less elegant than yq but that requires venv and pip install
    repo=$(grep "^repo:" "$version_file" | cut -d: -f2 | xargs )
    ver=$(grep "^version:" "$version_file" | cut -d: -f2 | xargs)
else
    echo "File $version_file not found."
    exit 1
fi
if [[ -z $ver ]]; then
    echo "Failed to get RMR version string from file $version_file"
    exit 1
fi
# default to release repo; accept override to use staging repo
repo=${repo:-"release"}
# 
for deb in "rmr_${ver}_amd64.deb" "rmr-dev_${ver}_amd64.deb"; do
    wget -nv --content-disposition "https://packagecloud.io/o-ran-sc/${repo}/packages/debian/stretch/${deb}/download.deb"
    sudo dpkg -i "${deb}"
    rm -f "${deb}"
done

echo "---> install-deb-rmr.sh ends"
