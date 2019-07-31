#!/bin/bash
#==================================================================================
#       Copyright (c) 2019 AT&T Intellectual Property.
#       Copyright (c) 2019 Nokia
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

set -eux -o pipefail
echo "--> export-packages.sh"

# Launches the docker image, which has an entrypoint script
# that copies artifacts created by the builder to a directory.
# Environment variables are injected in previous Jenkins steps.
# The push script searches the workspace, so do not use /tmp etc.
HOST=$WORKSPACE/export-packages-$$
GUEST=/export
mkdir -p "$HOST"
docker run -v "$HOST":"$GUEST" "$CONTAINER_PUSH_REGISTRY"/"$DOCKER_NAME":"$DOCKER_IMAGE_TAG" "$GUEST"
ls "$HOST"
