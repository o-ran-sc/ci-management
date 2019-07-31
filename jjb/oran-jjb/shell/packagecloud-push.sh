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
count=("$DEBIAN_DISTRIBUTION_VERSION")
echo "Debian distributions:" "${count[@]}"
debs=$(find . -type f -iname '*.deb')
# modern bash syntax is helpful
for (( i = 0; i < ${#count[@]}; i++ )); do
    for deb in $debs; do
       echo "Pushing $deb $PACKAGECLOUD_ACCOUNT/$PACKAGECLOUD_REPO/${count[i]}"
       package_cloud push "$PACKAGECLOUD_ACCOUNT"/"$PACKAGECLOUD_REPO"/"${count[i]}" "$deb"
    done
done

# For RPM
count=("$RPM_DISTRIBUTION_VERSION")
echo "RPM distributions:" "${count[@]}"
rpms=$(find . -type f -iregex '.*/.*\.\(s\)?rpm')
# modern bash syntax is helpful
for (( i = 0; i < ${#count[@]}; i++ )); do
    for rpm in $rpms; do
       echo "Pushing $rpm $PACKAGECLOUD_ACCOUNT/$PACKAGECLOUD_REPO/${count[i]}"
       package_cloud push "$PACKAGECLOUD_ACCOUNT"/"$PACKAGECLOUD_REPO"/"${count[i]}" "$rpm"
    done
done
