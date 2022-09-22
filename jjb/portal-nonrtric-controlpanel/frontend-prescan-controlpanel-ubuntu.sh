#!/bin/sh
##############################################################################
#
#   Copyright (C) 2022: Nordix Foundation
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
#
##############################################################################

echo "--> frontend-prescan-controlpanel-ubuntu.sh"

set -ex

# Assumes ubuntu - uses apt-get
sudo apt-get update
sudo apt-get install curl
# test execution
cd webapp-frontend
sudo curl -sL https://deb.nodesource.com/setup_13.x | bash -
sudo apt-get install nodejs
sudo apt-get install chromium-browser
export CHROME_BIN=/usr/bin/chromium-browser
./ng test --browsers ChromeHeadless --code-coverage=true --watch=false

echo "--> frontend-prescan-controlpanel-ubuntu.sh ends"
