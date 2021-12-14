#!/bin/bash

#   Copyright (C) 2020 Wind River Systems, Inc.
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

# Uploads a Yocto image to Nexus.

echo "--> upload-inf.sh"

# Ensure we fail the job if any steps fail.
set -eu -o pipefail

echo "INFO: creating virtual environment"
virtualenv -p python3 /tmp/venv
PATH=/tmp/venv/bin:$PATH

pip_pkgs="pip setuptools lftools"
for pkg in $pip_pkgs; do
    cmd_pip="python -m pip install -q --upgrade $pkg"
    echo "INFO: installing packages: $cmd_pip"
    $cmd_pip
done

# NEXUS_URL is set by Jenkins
nexus_repo_id="images"
nexus_repo_url="$NEXUS_URL/content/sites/$nexus_repo_id"
echo "INFO: upload to $nexus_repo_url"

repo_dir="$WORKSPACE/nexus/$nexus_repo_id"
# TODO: get build or version string; use latest for now
repo_iso_dir="$repo_dir/org/o-ran-sc/pti/rtp/latest"
echo "INFO: create staging directory $repo_iso_dir"
mkdir -p "$repo_iso_dir"

# Expect ISO file: oran-image-inf-host-intel-x86-64.iso
# in build subdir: workspace/prj_oran-inf/tmp-glibc/deploy/images/intel-x86-64/
#iso="workspace/prj_oran-inf/tmp-glibc/deploy/images/intel-x86-64/oran-image-inf-host-intel-x86-64.iso"
iso="workspace/prj_oran_inf_anaconda/tmp-glibc/deploy/images/intel-corei7-64/inf-image-aio-installer-intel-corei7-64.iso"
echo "INFO: copy $iso to staging directory $repo_iso_dir"
cp "$iso" "$repo_iso_dir"

cmd="lftools deploy nexus $nexus_repo_url $repo_dir"
echo "INFO: Upload ISO to Nexus: $cmd"
$cmd

echo "--> upload-inf.sh ends"
