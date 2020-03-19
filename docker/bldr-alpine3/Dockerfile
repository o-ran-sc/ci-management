# O-RAN-SC
#
# Copyright (C) 2019-2020 AT&T Intellectual Property and Nokia
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

# Builder image Alpine 3.9
# gcc/g++ v 8
# golang v 1.12
# python 3.7
# nng library (libnng.so, libnng.so.X.X.X; see below for pinned version)
# Includes RIC libraries as a distribution path because
# PackageCloud does not support Alpine .apk (yet):
# mdc log library (libmdclog.so, libmdbclog.so.X.X.X; see below for pinned version)
# rmr library (librmr_nng.so, libmdclog.so..X.X.X; see below for pinned version)
# Some packages install to /usr/local/lib, others to /usr/local/lib64
# Alpine by default searches /usr/local/lib but not /usr/local/lib64
#
# In a Docker build you can copy a library file from this Docker base image
# just update the tag appropriately:
# COPY --from=nexus3.o-ran-sc.org:10004/bldr-alpine3:some-tag /usr/local/lib64/libnng.so.X.X.X /usr/local/lib
# COPY --from=nexus3.o-ran-sc.org:10004/bldr-alpine3:some-tag /usr/local/lib64/librmr_nng.so.X.X.X /usr/local/lib
# COPY --from=nexus3.o-ran-sc.org:10004/bldr-alpine3:some-tag /usr/local/lib/libmdclog.so.X.X.X /usr/local/lib

FROM python:3.7-alpine
RUN apk update && apk add \
  autoconf \
  automake \
  build-base \
  cmake \
  libtool \
  ninja \
  pkgconfig \
  python-dev \
  sudo \
  git \
  go

# the autoconf-archive in alpine's edge repos is too new
# for our purposes, so we'll use one from the source.
RUN cd /tmp \
    && git clone --branch v2015.09.25 git://git.sv.gnu.org/autoconf-archive.git \
    && cp /tmp/autoconf-archive/m4/* /usr/share/aclocal \
    && rm -rf /tmp/autoconf-archive

# MCDLOG, version is pinned
RUN cd /tmp \
   && git clone --branch v0.0.4 https://gerrit.o-ran-sc.org/r/com/log \
   && cd log \
   && ./autogen.sh \
   && ./configure \
   && make \
   && make install

# install a well known working rmr, also pulls in nng
RUN apk update && apk add autoconf automake build-base cmake libtool ninja pkgconfig git sudo
RUN cd /tmp \
    && git clone --branch 3.6.1 https://gerrit.oran-osc.org/r/ric-plt/lib/rmr \
    && cd rmr \
    && mkdir .build; cd .build \
    && echo "<<<installing rmr devel headers>>>" \
    && cmake .. -DDEV_PKG=1; make install \
    && echo "<<< installing rmr .so>>>" \
    && cmake .. -DPACK_EXTERNALS=1; make install
