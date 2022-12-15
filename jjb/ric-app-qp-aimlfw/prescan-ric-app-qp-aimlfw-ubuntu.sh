#==================================================================================
#      Copyright (c) 2022 Samsung Electronics Co., Ltd. All Rights Reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#==================================================================================

echo "--> prescan-ric-app-qp-aimlfw-ubuntu.sh"

docker --version
echo "Unit Test"
cd $WORKSPACE


docker build --network=host -t tmpimg --target=qpaimlfwbuild .
CONTAINER=$(docker create tmpimg)
docker cp $CONTAINER:/tmp/qp_cover.out cover.out
docker rm $CONTAINER

echo "--> prescan-ric-app-qp-aimlfw.sh ends"
