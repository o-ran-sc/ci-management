#
#   Copyright (c) 2020 HCL Technology Pvt Ltd
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

#----------------------------------------------------------



echo "--> prescan-ric-plt-appmgr-ubuntu.sh starts"
cd $WORKSPACE
#docker build --network=host -t nexus3.o-ran-sc.org:10004/o-ran-sc/ric-plt-appmgr:0.5.0 .

sed -i 's,-cover,-coverprofile cover.out,' Dockerfile

docker  build --network=host -t tmpimg --target=appmgr-build .
CONTAINER=$(docker create tmpimg)
docker cp $CONTAINER:/go/src/ws/cover.out cover.out
docker rm $CONTAINER

echo "--> prescan-ric-plt-appmgr-ubuntu.sh ends"
