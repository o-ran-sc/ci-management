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
# standard packages: Go/C++, cmake, etc.
# RIC libraries: mcdlog (TODO), rmr

FROM alpine:3.9
RUN apk update && apk add \
  autoconf \
  automake \
  build-base \
  cmake \
  libtool \
  pkgconfig \
  git \
  go

# MCDLOG version 0.0.2, not pinned
# fails to build in Alpine
#RUN cd /tmp && git clone https://gerrit.o-ran-sc.org/r/com/log \
#  && cd log && ./autogen.sh && ./configure && make && make install

# RMR version 1.0.24
RUN cd /tmp && git clone https://gerrit.o-ran-sc.org/r/ric-plt/lib/rmr \
  && cd rmr && git checkout a012cf63dfdad3656c995cb06c316fd208c63b98 && cmake . && make install
