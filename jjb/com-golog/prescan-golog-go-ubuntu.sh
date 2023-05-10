#!/bin/bash
# Installs NNG then runs a build script in the repository
# Assumes ubuntu - uses apt-get

echo "--> prescan-golog-go-ubuntu.sh"

set -ex

sudo apt-get install -y cmake ninja-build

# NNG repo is not frequently tagged so it's pinned to a commit hash.
# This commit repairs bug https://github.com/nanomsg/nng/issues/970
git clone https://github.com/nanomsg/nng.git
(cd nng \
    && git checkout e618abf8f3db2a94269a79c8901a51148d48fcc2 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja \
    && sudo ninja install)
#!/bin/bash

#==================================================================================
#   Copyright (c) 2020 AT&T Intellectual Property.
#   Copyright (c) 2020 Nokia
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
#==================================================================================
# Go install, build, etc
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# xApp-framework stuff
export CFG_FILE=../config/config-file.json
export RMR_SEED_RT=../config/uta_rtg.rt

# shellcheck disable=SC2034
GO111MODULE=on GO_ENABLED=0 GOOS=linux

# setup version tag
if [ -f container-tag.yaml ]
then
    tag=$(grep "tag:" container-tag.yaml | awk '{print $2}')
else
    tag="no-tag-found"
fi

hash=$(git rev-parse --short HEAD || true)

# Build

go build -a -installsuffix cgo -ldflags "-X main.Version=$tag -X main.Hash=$hash" -o ./cmd/*.go


# Test and coverage
# install the go coverage tool helper
go get -v github.com/ory/go-acc
go-acc . -o cover.out


echo "--> build_com-golog_ubuntu.sh ends"

echo "--> prescan-golog-go-ubuntu.sh ends"
