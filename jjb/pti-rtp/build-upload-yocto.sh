#!/bin/bash

#   Copyright (C) 2019 Wind River Systems, Inc.
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

# Builds a Yocto image and uploads to Nexus.
# Assumes prereqs have already been installed.

echo "--> build-upload-yocto.sh"

# Ensure we fail the job if any steps fail.
set -eu -o pipefail

dir=workspace
echo "INFO: creating workspace $dir"
mkdir $dir
cmd="./scripts/build_oran.sh -w $dir"
echo "INFO: invoking build script: $cmd"
$cmd

# NEXUS_URL is set by Jenkins
nexus_repo_id="images"
nexus_repo_url="$NEXUS_URL/content/sites/$nexus_repo_id"
echo "INFO: upload to NEXUS repo URL $nexus_repo_url"

repo_dir="$WORKSPACE/nexus/$nexus_repo_id"
# TODO: get build or version string; use latest for now
repo_iso_dir="$repo_dir/org/o-ran-sc/pti/rtp/latest"
echo "$INFO: create staging directory $repo_iso_dir"
mkdir -p "$repo_iso_dir"

# Expect ISO file: oran-image-inf-host-intel-x86-64.iso
# in build subdir: prj_oran-inf/tmp-glibc/deploy/images/intel-x86-64/
iso="${dir}/prj_oran-inf/tmp-glibc/deploy/images/intel-x86-64/oran-image-inf-host-intel-x86-64.iso" 
echo "INFO: copy $iso to staging directory $repo_iso_dir"
cp "$iso" "$repo_iso_dir"

cmd="lftools deploy nexus $nexus_repo_url $repo_dir"
echo "INFO: Upload ISO to Nexus: $cmd"
$cmd

echo "--> build-upload-yocto.sh ends"
