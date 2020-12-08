#!/bin/bash
##############################################################################
#
#   Copyright (c) 2020 AT&T Intellectual Property.
#   Copyright (c) 2020 Nokia.
#   Copyright (c) 2020 HCL Technologies
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

echo "--> setup-dbaas-build-deb.sh"

# Ensure we fail the job if any steps fail.
set -eux -o pipefail

# NOTE: The valgrind false positive problem could also potentially be solved
# with valgrind suppression files but that kind of approach may be fragile.

# install prereqs
sudo apt-get update && sudo apt-get -q -y install \
   automake \
    autoconf \
    cmake \
    curl \
    g++ \
    gcc \
    libtool \
    make \
    pkg-config \
    valgrind \
    lcov

# Cpputest built-in memory checks generate false positives in valgrind.
# This is solved by compiling cpputest with memory checking disabled.

mkdir -p cpputest/builddir
cd cpputest

curl -L https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz | \
    tar --strip-components=1 -xzf -
cd builddir
cmake -DMEMORY_LEAK_DETECTION=OFF .. && \
sudo make install
cd ../..
# generate configure script
cd redismodule
./autogen.sh && \
    ./configure && \
sudo make test

# generate configure script with memory checking disabled.

./autogen.sh && \
    ./configure --disable-unit-test-memcheck && \
sudo make test
cd ..

#Copy configure to $WORKSPACE

cp -r cpputest/* .

echo "--> setup-dbaas-build-deb.sh ends"