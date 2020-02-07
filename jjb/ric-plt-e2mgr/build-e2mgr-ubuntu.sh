#!/bin/sh
##############################################################################
#
#   Copyright (c) 2020 AT&T Intellectual Property.
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

# Installs libraries and builds E2 manager
# Prerequisites:
#   Debian distro; e.g., Ubuntu
#   cmake (version?)
#   gcc/g++ compiler (version?)
#   golang (go), tested with version 1.12
#   current working directory is freshly cloned repo

# TODO:
# 1) drop go from $PATH when build minion is extended
# 2) drop rewrite of path prefix when SonarScanner is extended

# Stop at first error and be verbose
set -eux

# Build and install NNG, which requires ninja
sudo apt-get install ninja-build
git clone https://github.com/nanomsg/nng.git \
    && cd nng \
    && git checkout e618abf8f3db2a94269a79c8901a51148d48fcc2 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja \
    && sudo ninja install \
    && cd ../.. \
    && rm -r nng

# Install RMR from deb packages at packagecloud.io
rmr=rmr_1.13.0_amd64.deb
wget --content-disposition  https://packagecloud.io/o-ran-sc/staging/packages/debian/stretch/$rmr/download.deb
sudo dpkg -i $rmr
rm $rmr
rmrdev=rmr-dev_1.13.0_amd64.deb
wget --content-disposition https://packagecloud.io/o-ran-sc/staging/packages/debian/stretch/$rmrdev/download.deb
sudo dpkg -i $rmrdev
rm $rmrdev

# required to find nng and rmr libs
export LD_LIBRARY_PATH=/usr/local/lib

# go installs tools like go-acc to $HOME/go/bin
# ubuntu minion path lacks go
export PATH=$PATH:$HOME/go/bin:/opt/go/1.12/bin
# install the go coverage tool helper
go get -v github.com/ory/go-acc

# Remaining commands assume $CWD is E2Manager
cd E2Manager

cd 3rdparty/asn1codec \
    && make \
    && cd ../..

go build -v app/main.go

# Execute UT and measure coverage
# cgocheck=2 enables expensive checks that should not miss any errors, but will cause your program to run slower.
# clobberfree=1 causes the garbage collector to clobber the memory content of an object with bad content when it frees the object.
# gcstoptheworld=1 disables concurrent garbage collection, making every garbage collection a stop-the-world event.
# Setting gcstoptheworld=2 also disables concurrent sweeping after the garbage collection finishes.
# Setting allocfreetrace=1 causes every allocation to be profiled and a stack trace printed on each object's allocation and free.
export GODEBUG=cgocheck=2,clobberfree=1,gcstoptheworld=2,allocfreetrace=0
export RIC_ID="bbbccc-abcd0e/20"
# TODO is RMR_SEED_RT needed?
# export RMR_SEED_RT=/tmp/router_test.txt
# writes to coverage.txt by default
# SonarCloud accepts the text format
go-acc $(go list ./... | grep -vE '(/mocks|/tests|/e2managererrors|/enums)' )

# rewrite the module name to a directory name in the coverage report
# https://jira.sonarsource.com/browse/SONARSLANG-450
sed -i -e 's/^e2mgr/E2Manager/' coverage.txt
