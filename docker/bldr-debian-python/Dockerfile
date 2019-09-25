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

# Builder image with CI tools for RIC components
# uses Python 3.7 (Debian stretch) base which has
# C and C++ tools from buildpack-deps:stretch then adds:
# Ninja 1.9 from binary distro to /usr/local/bin
# Nanomsg Next Gen libs by cloning and building

FROM python:3.7

RUN apt-get update && apt-get -q -y install \
  autoconf \
  autoconf-archive \
  automake \
  cmake \
  libtool \
  pkg-config

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
