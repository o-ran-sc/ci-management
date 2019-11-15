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

# Tests creation of a Yocto image.  The "-n" flag skips bitbake.
# Assumes prereqs have already been installed.

echo "--> verify-yocto.sh"

# Ensure we fail the job if any steps fail.
set -eu -o pipefail

dir=workspace
echo "INFO: creating workspace $dir"
mkdir $dir
cmd="./scripts/build_oran.sh -w $dir -n"
echo "INFO: invoking build script: $cmd"
$cmd

echo "--> verify-yocto.sh ends"
