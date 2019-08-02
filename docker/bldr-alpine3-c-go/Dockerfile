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

# Builder image: Alpine 3.9
# standard packages: C, C++, cmake, golang, etc.
# third-party library: NNG
# RIC libraries: rmr

# Unlike other base images, this INCLUDES the RMr library
# as a convenient way to distribute that library for Alpine.
# At present we cannot easily build nor distribute .apk packages.
# Get the RMR for NNG library from a Docker base image like this:
# COPY --from=nexus3.o-ran-sc.org:10004/bldr-alpine3-c-go:1-a3.9-nng1.1.1 /usr/local/lib/librmr_nng.so.1.0.36 /usr/local/lib

FROM alpine:3.9
RUN apk update && apk add \
  autoconf \
  automake \
  build-base \
  cmake \
  libtool \
  ninja \
  pkgconfig \
  python-dev \
  git \
  go

# the autoconf-archive in alpine's edge repos is too new
# for our purposes, so we'll use one from the source.
RUN cd /tmp \
    && git clone --branch v2015.09.25 git://git.sv.gnu.org/autoconf-archive.git \
    && cp /tmp/autoconf-archive/m4/* /usr/share/aclocal \
    && rm -rf /tmp/autoconf-archive

# NNG, version is pinned
RUN cd /tmp \
    && git clone --branch v1.1.1 https://github.com/nanomsg/nng.git \
    && cd nng \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=1 -G Ninja .. \
    && ninja \
    && ninja install

# RMR, version is pinned
RUN cd /tmp \
    && git clone --branch 1.0.36 https://gerrit.o-ran-sc.org/r/ric-plt/lib/rmr \
    && cd rmr \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install

# MCDLOG, version is NOT pinned
# Compile fails
# RUN cd /tmp \
#    && git clone https://gerrit.o-ran-sc.org/r/com/log \
#    && cd log \
#    && ./autogen.sh \
#    && ./configure \
#    && make \
#    && make install
