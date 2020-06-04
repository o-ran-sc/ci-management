#!/bin/bash

#   Copyright (C) 2019 Wind River Systems, Inc.
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

# Installs Yocto build prerequisites on CentOS.

echo "--> install-yocto-prereq-centos.sh"

# Ensure we fail the job if any steps fail.
set -eu -o pipefail

pkgs="gawk make wget tar bzip2 gzip python unzip perl patch \
     diffutils diffstat cpp gcc gcc-c++ glibc-devel texinfo chrpath socat \
     perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue perl-Digest-SHA \
     python3-pip xz which SDL-devel xterm"
echo "INFO: installing epel-release and packages $pkgs"
sudo yum install -y epel-release \
  && sudo yum makecache \
  && sudo yum install -y $pkgs

git config --global user.name "oran inf builder"
git config --global user.email "oran.inf@windriver.com"

echo "--> install-yocto-prereq-centos.sh ends"
