#!/bin/bash
# SPDX-License-Identifier: EPL-1.0
##############################################################################
# Copyright (c) 2020 HCL Technologies and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################
echo "---> cmake-sonarqube.sh"
cd mgxapp
docker build -t ric-plt-utils -f Dockerfile.build .
docker create --name  ric-plt-utils ric-plt-utils
docker cp ric-plt-utils:/playpen/build/test/ .
docker rm ric-plt-utils
echo "---> cmake-sonarqube.sh ends"