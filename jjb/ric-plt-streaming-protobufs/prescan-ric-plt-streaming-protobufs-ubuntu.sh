echo "starting prescan-ric-plt-streaming-protobufs-ubuntu.sh"

#!/bin/sh
#
#  Copyright (c) 2019 AT&T Intellectual Property.
#  Copyright (c) 2018-2019 Nokia.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#   This source code is part of the near-RT RIC (RAN Intelligent Controller)
#   platform project (RICP).
# Go install, build, etc
set -e


cd $WORKSPACE/protogen/go/streaming_protobufs

export GO111MODULE=on
go mod download
#No _test.go file for coverage report

go test $WORKSPACE/protogen/go/streaming_protobufs/ -v -coverprofile cover.out

echo " prescan-ric-plt-streaming-protobufs-ubuntu.sh ends"
