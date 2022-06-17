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

# Installs Debian package 'alien' to support building RPMs

echo "---> install-deb-cpprest.sh"

# stop on error or unbound var, and be chatty
set -eux
sudo apt-get update --fix-misisng && sudo apt-get -q -y install libcpprest-dev

echo "---> install-deb-cpprest.sh ends"
