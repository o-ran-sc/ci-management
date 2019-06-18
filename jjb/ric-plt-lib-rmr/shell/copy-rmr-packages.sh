#!/bin/bash -l
# use login flag to get $HOME/.local/bin in PATH
# bcos pip installs yq to $HOME/.local/bin

#==================================================================================
#       Copyright (c) 2019 Nokia
#       Copyright (c) 2018-2019 AT&T Intellectual Property.
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
echo "--> copy-rmr-packages.sh"

# extracts artifacts created by the builder
# file with paths of generated deb, rpm packages
pkgs="build_packages.yml"

# access builder files within a container created by running a trivial command
# environment variables are injected in previous Jenkins steps
container=$(docker run -d "$CONTAINER_PUSH_REGISTRY"/"$DOCKER_NAME":"$DOCKER_IMAGE_TAG" ls)
docker cp "${container}:/tmp/${pkgs}" .

count=$(yq -r '.files | length' $pkgs)
# modern bash syntax is helpful
for (( i = 0; i < count; i++ )); do
    file=$(yq -r ".files[$i]" "$pkgs")
    docker cp "$container":"$file" .
    base=$(basename "$file")
    echo "Push file $base" # TODO
done
