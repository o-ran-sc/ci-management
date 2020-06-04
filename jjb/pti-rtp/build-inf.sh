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

# Builds a Yocto image for real.
# Assumes prereqs have already been installed.

echo "--> build-inf.sh"

# Ensure we fail the job if any steps fail.
set -eu -o pipefail

dir=workspace
echo "INFO: creating workspace $dir"
mkdir $dir
cmd="./scripts/build_inf.sh -w $dir"
echo "INFO: invoking build script: $cmd"
$cmd
echo "--> build-inf.sh ends"
