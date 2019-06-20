#   Copyright (c) 2019 AT&T Intellectual Property.
#   Copyright (c) 2019 Nokia.
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
FROM python:3-alpine AS bldr-alpine-python-nng

# 1. required packages.
RUN apk update
RUN apk add build-base
RUN apk add git
RUN apk add autoconf
RUN apk add automake
RUN apk add cmake
RUN apk add ninja
RUN apk add libtool
RUN apk add alpine-sdk

WORKDIR /tmp/

# the autoconf-archive in alpine's edge repos is too new
# for our purposes, so we'll use one from the source.
RUN git clone --branch v2015.09.25 git://git.sv.gnu.org/autoconf-archive.git
RUN cp /tmp/autoconf-archive/m4/* /usr/share/aclocal
RUN rm -rf /tmp/autoconf-archive

RUN git clone https://github.com/nanomsg/nng
WORKDIR /tmp/nng
RUN git checkout v1.1.1
RUN mkdir /tmp/nng/build
WORKDIR /tmp/nng/build
RUN cmake -DBUILD_SHARED_LIBS=1 -G Ninja ..
RUN ninja
RUN ninja install
WORKDIR /tmp/
RUN rm -rf /tmp/nng
