#!/bin/sh
##############################################################################
#
#   Copyright (C) 2021: Nordix Foundation
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

echo "--> prescan-ransliceassurance-ubuntu.sh"

set -ex

# Assumes ubuntu - uses apt-get
sudo apt-get update

# build script execution
bash smoversion/build-ransliceassurance-ubuntu.sh
bash icsversion/build-ransliceassurance-ubuntu.sh

echo "--> prescan-ransliceassurance-ubuntu.sh ends"
