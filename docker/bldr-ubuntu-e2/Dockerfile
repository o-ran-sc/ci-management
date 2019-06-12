# O-RAN-SC
#
# Copyright (C) 2019 AT&T Intellectual Property and Nokia
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

# Builder image for E2
# Ubuntu 16 plus standard packages gcc g++ sctp boost etc.
# Adds binary dist of Golang version 1.11
# Adds Cmake 3.13.4 by cloning and building
# Adds Nanomsg latest by cloning and building

FROM ubuntu:16.04
 
RUN apt-get update \
    && apt-get install -y \
    build-essential software-properties-common \
    git zip wget make gcc g++  \
    libsctp-dev lksctp-tools \
    zlibc zlib1g zlib1g-dev \
    python-dev autotools-dev libicu-dev libbz2-dev libboost-all-dev \
    autoconf autoconf-archive libtool automake pkg-config

RUN add-apt-repository -y ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install -y golang-1.11

WORKDIR /opt 
RUN wget -nv https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4-Linux-x86_64.sh \
    && chmod +x cmake-3.13.4-Linux-x86_64.sh \
    && ./cmake-3.13.4-Linux-x86_64.sh --skip-license
 
RUN wget -nv https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip \
    && unzip ninja-linux.zip \
    && cp ninja /usr/sbin/ \
    && chmod +x /usr/sbin/ninja

RUN git clone https://github.com/nanomsg/nng.git \
    && cd nng && mkdir build \
    && cd build \
    && /opt/bin/cmake -G Ninja .. \
    && ninja && ninja install
