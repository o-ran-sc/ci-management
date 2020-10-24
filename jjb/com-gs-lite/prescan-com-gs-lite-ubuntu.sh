#!/bin/sh

echo "---> cmake-sonarqube.sh starts"

CMAKE_OPTS=
BUILD_DIR=$WORKSPACE/src
BUILD_WRAP_DIR=$WORKSPACE/bw-output


build_dir="${BUILD_DIR:-$WORKSPACE/build}"
build_wrap_dir="${BUILD_WRAP_DIR:-$WORKSPACE/bw-output}"
cmake_opts="${CMAKE_OPTS:-}"
make_opts="${MAKE_OPTS:-}"

cd src || exit 1
wget -q -O bw.zip https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip
unzip -q bw.zip
sudo mv build-wrapper-* /opt/build-wrapper

mkdir -p "$build_dir"
cd "$build_dir" || exit 1


# $make_opts may be empty.
# shellcheck disable=SC2086
/opt/build-wrapper/build-wrapper-linux-x86-64 --out-dir "$build_wrap_dir" make $make_opts

echo "---> cmake-sonarqube.sh ends"
