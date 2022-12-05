#!/bin/bash

# O-RAN-SC
#
# Copyright (C) 2020 AT&T Intellectual Property and Nokia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Installs Debian package 'pistache' to support building RPMs

echo "---> install-git-RESTful.sh"

# stop on error or unbound var, and be chatty
set -eux
echo "---> install RESTful API dependencies..."

#export PATH=$PATH:~/.local/bin
#export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu

#building and installing cpprestsdk
sudo apt-get install -y libcpprest-dev

sudo apt-get install -y  g++ git libboost-atomic-dev libboost-thread-dev libboost-system-dev libboost-date-time-dev libboost-regex-dev libboost-filesystem-dev libboost-random-dev libboost-chrono-dev libboost-serialization-dev libwebsocketpp-dev openssl libssl-dev ninja-build zlib1g-dev

sudo git clone https://github.com/Microsoft/cpprestsdk.git casablanca && \
    cd casablanca && \
    mkdir build && \
    cd build && \
    cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF -DBUILD_SAMPLES=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    ninja && \
    ninja install && \
    cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DBUILD_TESTS=OFF -DBUILD_SAMPLES=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    ninja && \
    ninja install

cd ../../



#installing all dependicies for pistache
sudo apt-get update && sudo apt-get -y install ninja-build python python3-pip libcurl4-openssl-dev libssl-dev pkg-config
python3 -m pip install meson


git clone https://github.com/Tencent/rapidjson && \
        cd rapidjson && \
        mkdir build && \
        cd build && \
        cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
        make install

cd ../../


#building and installing pistache
git clone https://github.com/pistacheio/pistache.git

cd pistache && \
    meson setup build \
    --buildtype=release \
    -DPISTACHE_USE_SSL=true \
    -DPISTACHE_BUILD_EXAMPLES=true \
    -DPISTACHE_BUILD_TESTS=true \
    -DPISTACHE_BUILD_DOCS=false \
    --prefix="/usr/local"

cd build && \
   ninja && \
   ninja install
cp /usr/local/lib/x86_64-linux-gnu/libpistache* /usr/local/lib/
cp /usr/local/lib/x86_64-linux-gnu/pkgconfig/libpistache.pc /usr/local/lib/pkgconfig
cd ../../


#install nlohmann json
git clone https://github.com/nlohmann/json.git && cd json && cmake . && make install
cd ../
#install json-schema-validator
git clone https://github.com/pboettch/json-schema-validator.git && cd json-schema-validator &&mkdir build &&cd build && cmake .. && make install
cd ../


export LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib
export C_INCLUDE_PATH=/usr/local/include

echo "---> install-git-RESTful.sh ends"

