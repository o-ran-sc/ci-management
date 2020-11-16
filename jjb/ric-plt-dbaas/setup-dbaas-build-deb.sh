#!/bin/bash
##############################################################################
#
#   Copyright (c) 2020 HCL Technology.
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

# Installs prerequisites needed to compile & test SDL code
# and build RPM/DEB packages on a Debian/Ubuntu machine.

echo "--> setup-sdl-build-deb.sh"

# Ensure we fail the job if any steps fail.
set -eux -o pipefail

# install prereqs
sudo apt-get update && sudo apt-get -q -y install \
  autoconf-archive libhiredis-dev rpm valgrind \
  libboost-filesystem-dev libboost-program-options-dev libboost-system-dev

# generate configure script
cd redismodule
autoreconf --install
cd ..
curl -L https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz | \
    tar --strip-components=1 -xzf -
cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_COVERAGE=ON -DMEMORY_LEAK_DETECTION=OFF .
sudo make install
echo "--> setup-sdl-build-deb.sh ends"