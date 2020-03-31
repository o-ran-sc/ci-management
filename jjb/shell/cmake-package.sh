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

# Creates a build directory then invokes cmake and make
# from that dir with only the specified options/targets.
# Supports projects that create DEB/RPM package files for
# upload to PackageCloud or other repository, which must
# use a system install prefix like /usr/local.  Calling
# the "install" goal with a system prefix requires sudo,
# but building a package doesn't require the install step.
# Prereqs:
# The build minion has cmake, make, gcc etc.
# Environment variables:
# WORKSPACE is a non-empty path (required)
# CMAKE_INSTALL_PREFIX is a non-empty path (required)
# BUILD_DIR is a path (optional; has usable default)
# CMAKE_OPTS has options for cmake (optional, empty default)
# MAKE_OPTS has options for make (optional, empty default)

echo "---> cmake-package.sh"

build_dir="${BUILD_DIR:-$WORKSPACE/build}"
cmake_opts="${CMAKE_OPTS:-}"
make_opts="${MAKE_OPTS:-}"
echo "build_dir:  $build_dir"
echo "cmake_opts: $cmake_opts"
echo "make_opts:  $make_opts"

# be careful and verbose
set -eux -o pipefail

mkdir -p "$build_dir"
cd "$build_dir" || exit
cmake -version
# $cmake_opts needs to wordsplit to pass options.
# shellcheck disable=SC2086
eval cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" $cmake_opts ..
make -version
# $make_opts needs to wordsplit to pass options.
# shellcheck disable=SC2086
make $make_opts

echo "---> cmake-package.sh ends"
