echo "---> install common-packer start"

git clone https://gerrit.o-ran-sc.org/r/ci-management
cd ci-management/packer
git rm common-packer
COMMON_PACKER_VERSION=v0.14.1
git submodule add https://github.com/lfit/releng-common-packer common-packer
cd common-packer
git checkout $COMMON_PACKER_VERSION
sudo ./provision/install-python.sh

echo "---> install common-packer end"
