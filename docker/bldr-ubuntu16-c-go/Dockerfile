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

# Builder image with superset of CI tools for RIC components

FROM nexus3.o-ran-sc.org:10001/ubuntu:16.04

RUN apt-get update && apt-get install -y \
    autoconf \
    autoconf-archive \
    automake \
    autotools-dev \
    build-essential \
    g++  \
    gcc \
    git \
    libbz2-dev \
    libicu-dev \
    libsctp-dev \
    libtool \
    lksctp-tools \
    make \
    python-dev \
    pkg-config \
    software-properties-common \
    wget \
    zlib1g \
    zlib1g-dev \
    zlibc \
    zip

WORKDIR /tmp

RUN wget -nv https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5-Linux-x86_64.sh \
    && chmod +x cmake-3.14.5-Linux-x86_64.sh \
    && ./cmake-3.14.5-Linux-x86_64.sh --prefix=/usr/local --skip-license

RUN wget -nv https://dl.google.com/go/go1.12.linux-amd64.tar.gz \
    && tar -xf go1.12.linux-amd64.tar.gz \
    && mv go /usr/local
ENV PATH=$PATH:/usr/local/go/bin:/usr/lib/go-1.12/bin
RUN go get -u github.com/ory/go-acc \
    && mv ~/go/bin/go-acc /usr/local/go/bin

RUN wget -nv https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip \
    && unzip sonar-scanner-cli-3.2.0.1227-linux.zip \
    && mv sonar-scanner-3.2.0.1227-linux /usr/local/

RUN wget -nv https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip \
    && unzip ninja-linux.zip \
    && chmod +x ninja \
    && mv ninja /usr/local/bin

# NNG repo is not frequently tagged so it's pinned to a commit hash.
# This commit provides fix to the proxy-reconnect
# bug that we identified:  https://github.com/nanomsg/nng/issues/970
RUN git clone https://github.com/nanomsg/nng.git \
    && cd nng \
    && git checkout e618abf8f3db2a94269a79c8901a51148d48fcc2 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja \
    && ninja install

RUN wget -nv https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.zip \
    && unzip -q boost_1_69_0.zip \
    && cd boost_1_69_0 \
    && ./bootstrap.sh --prefix=/usr/ \
    && ./b2 \
    && ./b2 install \
    && cd ../ \
    && rm -rf boost_1_69_0.zip boost_1_69_0
