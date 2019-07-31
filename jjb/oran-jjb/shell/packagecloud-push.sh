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
echo "---> packagecloud-push.sh"
set -eu -o pipefail

if [ ! -f ~/.packagecloud ]; then
    echo "INFO: .packagecloud file not found"
    exit 0
fi

 # For DEB
vers=("$DEBIAN_DISTRIBUTION_VERSIONS")
echo "Debian distribution versions:" "${vers[@]}"
debs=$(find . -type f -iname '*.deb')
# modern bash syntax is helpful
for (( i = 0; i < ${#vers[@]}; i++ )); do
    for deb in $debs; do
       echo "Pushing $deb $PACKAGECLOUD_ACCOUNT/$PACKAGECLOUD_REPO/${vers[i]}"
       package_cloud push "$PACKAGECLOUD_ACCOUNT"/"$PACKAGECLOUD_REPO"/"${vers[i]}" "$deb"
    done
done

# For RPM
vers=("$RPM_DISTRIBUTION_VERSIONS")
echo "RPM distribution versions:" "${vers[@]}"
rpms=$(find . -type f -iregex '.*/.*\.\(s\)?rpm')
# modern bash syntax is helpful
for (( i = 0; i < ${#vers[@]}; i++ )); do
    for rpm in $rpms; do
       echo "Pushing $rpm $PACKAGECLOUD_ACCOUNT/$PACKAGECLOUD_REPO/${vers[i]}"
       package_cloud push "$PACKAGECLOUD_ACCOUNT"/"$PACKAGECLOUD_REPO"/"${vers[i]}" "$rpm"
    done
done
