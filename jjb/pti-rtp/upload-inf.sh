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

if [[ -f ~/lf-env.sh ]]; then
    # shellcheck source=/dev/null
    . ~/lf-env.sh
fi

# An agent's ~/lf-env.sh is copied when it boots, so may predate lftools-uv.
if ! declare -F lftools-uv > /dev/null; then
    lf_env="$(mktemp)"
    lf_env_url="https://raw.githubusercontent.com/lfit/releng-global-jjb"
    wget -nv -O "$lf_env" "$lf_env_url/${GLOBAL_JJB_VERSION:-master}/jenkins-init-scripts/lf-env.sh" || true
    # shellcheck source=/dev/null
    . "$lf_env"
    rm -f "$lf_env"
    if ! declare -F lftools-uv > /dev/null; then
        echo "ERROR: lf-env.sh has no lftools-uv function" >&2
        exit 1
    fi
fi

# NEXUS_URL is set by Jenkins
nexus_repo_id="images"
nexus_repo_url="$NEXUS_URL/content/sites/$nexus_repo_id"
echo "INFO: upload to $nexus_repo_url"

repo_dir="$WORKSPACE/nexus/$nexus_repo_id"
repo_iso_dir_latest="$repo_dir/org/o-ran-sc/pti/rtp/latest"
repo_iso_dir_branch="$repo_dir/org/o-ran-sc/pti/rtp/$GERRIT_BRANCH"
echo "INFO: create staging directory $repo_iso_dir_latest and $repo_iso_dir_branch"
mkdir -p "$repo_iso_dir_latest" "$repo_iso_dir_branch"

# Expect Yocto based ISO file: inf-image-yocto-aio-x86-64.iso
# in build subdir: workspace/workspace_yocto/prj_output/
iso_yocto="workspace/workspace_yocto/prj_output/inf-image-yocto-aio-x86-64.iso"

# Expect Debian based ISO file: inf-image-debian-all-x86-64.iso
# in build subdir: workspace/workspace_debian/prj_output/
iso_debian="workspace/workspace_debian/prj_output/inf-image-debian-all-x86-64.iso"

# Expect CentOS based ISO file: inf-image-centos-all-x86-64.iso
# in build subdir: workspace/workspace_centos/prj_output/
iso_centos="workspace/workspace_centos/prj_output/inf-image-centos-all-x86-64.iso"

for iso_dir in $repo_iso_dir_latest $repo_iso_dir_branch; do
    echo "INFO: copy ISO images to staging directory $iso_dir"
    for iso_img in $iso_yocto $iso_centos $iso_debian; do
        if [[ -f $iso_img ]]; then
            echo "INFO: copying $iso_img"
            cp "$iso_img" "$iso_dir"
        fi
    done
done

echo "INFO: Upload ISO to Nexus: lftools-uv deploy nexus --allow-empty $nexus_repo_url $repo_dir"
# lftools-uv fails a deploy with nothing to upload, which legacy lftools
# allowed: no ISO is staged when a build produces none.
lftools-uv deploy nexus --allow-empty "$nexus_repo_url" "$repo_dir"

echo "--> upload-inf.sh ends"
