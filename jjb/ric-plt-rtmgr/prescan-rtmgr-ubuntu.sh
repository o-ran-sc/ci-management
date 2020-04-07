#!/bin/sh
##############################################################################
#
#   Copyright (c) 2020 AT&T Intellectual Property.
#   Copyright (c) 2019 Nokia.
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
#
##############################################################################

# Installs NNG then runs a build script in the repository
# Assumes ubuntu - uses apt-get

echo "--> prescan-rtmgr-ubuntu.sh"

set -ex

sudo apt-get update && sudo apt-get install -y cmake ninja-build

# build script must start in this subdir
bash ./build-rtmgr-ubuntu.sh

echo "--> prescan-rtmgr-ubuntu.sh ends"
