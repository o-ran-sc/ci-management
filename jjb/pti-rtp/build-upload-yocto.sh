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

NEXUS_REPO_URL="https://nexus.o-ran-sc.org/content/sites/images"
NEXUS_URL="https://nexus.o-ran-sc.org"
NEXUS_REPO_ID="images"
echo "INFO: TODO: upload to NEXUS_REPO_URL $NEXUS_REPO_URL"
echo "INFO: TODO: upload to NEXUS_URL      $NEXUS_URL"
echo "INFO: TODO: upload to NEXUS_REPO_ID  $NEXUS_REPO_ID"

echo "--> build-upload-yocto.sh ends"
