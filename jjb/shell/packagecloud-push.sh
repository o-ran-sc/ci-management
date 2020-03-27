#!/bin/bash -l
# SPDX-License-Identifier: EPL-1.0
##############################################################################
# Copyright (c) 2019 The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################

# Prereqs and environment variables:
# The build minion has the ruby gem "package_cloud"
# The credentials file has been provisioned
# DEBIAN_DISTRIBUTION_VERSIONS has distro list like "debian/stretch"
# RPM_DISTRIBUTION_VERSIONS has distro list like "el/4 el/5"
# PACKAGE_PREFIX has first part of package file names; e.g., "mylib"
# PACKAGECLOUD_ACCOUNT is set and non-empty
# PACKAGECLOUD_REPO is a value like "staging"

echo "---> packagecloud-push.sh"
set -eu -o pipefail

# Credentials for PackageCloud.io
pc="$HOME/.packagecloud"
if [[ ! -f $pc ]]; then
    echo "ERROR: credentials file $pc not found"
    exit 1
fi

echo "Searching for files with prefix: $PACKAGE_PREFIX"

 # For DEB
vers=("$DEBIAN_DISTRIBUTION_VERSIONS")
echo "Debian distribution versions: " "${vers[@]}"
debs=$(find . -type f -iname "${PACKAGE_PREFIX}*.deb")
echo "Debian package files: $debs"
# modern bash syntax is helpful
for (( i = 0; i < ${#vers[@]}; i++ )); do
    for deb in $debs; do
       arg="${PACKAGECLOUD_ACCOUNT}/${PACKAGECLOUD_REPO}/${vers[i]}"
       echo "Pushing $deb as $arg"
       package_cloud push "$arg" "$deb"
    done
done

# For RPM
vers=("$RPM_DISTRIBUTION_VERSIONS")
echo "RPM distribution versions: " "${vers[@]}"
rpms=$(find . -type f -iname "${PACKAGE_PREFIX}*.rpm")
echo "RPM package files: $rpms"
# modern bash syntax is helpful
for (( i = 0; i < ${#vers[@]}; i++ )); do
    for rpm in $rpms; do
       arg="${PACKAGECLOUD_ACCOUNT}/${PACKAGECLOUD_REPO}/${vers[i]}"
       echo "Pushing $rpm as $arg"
       package_cloud push "$arg" "$rpm"
    done
done
