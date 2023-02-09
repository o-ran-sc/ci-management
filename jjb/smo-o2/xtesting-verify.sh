#!/bin/bash

echo "Starting Script"
touch start.txt
git clone https://gerrit.o-ran-sc.org/r/ci-management
cd ci-management/packer || exit
git rm common-packer
COMMON_PACKER_VERSION=v0.14.1
git submodule add https://github.com/lfit/releng-common-packer common-packer
cd common-packer || exit
git checkout $COMMON_PACKER_VERSION

sudo ./provision/install-python.sh
sudo pip install ansible
sudo ansible-playbook -i hosts ./provision/devstack.yaml
source devstack/openrc nfv_user nfv
openstack vnf package create
touch end.txt
