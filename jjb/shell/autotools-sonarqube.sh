#!/bin/bash
# SPDX-License-Identifier: EPL-1.0
##############################################################################
# Copyright (c) 2020 The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################

# Invokes configure and make with the specified options,
# using a wrapper for the SonarQube Jenkins plug-in
# https://docs.sonarqube.org/latest/analysis/languages/cfamily/
# Prereqs:
# The build minion has make, gcc etc.
# The project repo has an executable shell script "configure"
# Environment variables:
# WORKSPACE is a non-empty path (required)
# INSTALL_PREFIX is a non-empty path (required)
# CONFIGURE_OPTS has options for configure (optional, empty default)
# MAKE_OPTS has options for make (optional, empty default)
# BUILD_WRAP_DIR is a path (optional, this provides a usable default)

echo "---> autotools-sonarqube.sh"

# be careful and verbose
set -eux -o pipefail

c="$WORKSPACE/configure"
if [[ ! -f $c || ! -x $c ]]; then
    echo "ERROR: failed to find executable file $c"
    exit 1
fi

configure_opts="${CONFIGURE_OPTS:-}"
make_opts="${MAKE_OPTS:-}"
build_wrap_dir="${BUILD_WRAP_DIR:-$WORKSPACE/bw-output}"

# download and install the Sonar build wrapper
cd /tmp || exit 1
wget -q -O bw.zip https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip
unzip -q bw.zip
sudo mv build-wrapper-* /opt/build-wrapper

# configure needs to wordsplit to pass options.
# shellcheck disable=SC2086
"$c" --prefix="$INSTALL_PREFIX" $configure_opts

# $make_opts may be empty.
# shellcheck disable=SC2086
/opt/build-wrapper/build-wrapper-linux-x86-64 --out-dir "$build_wrap_dir" make $make_opts

echo "---> autotools-sonarqube.sh ends"
