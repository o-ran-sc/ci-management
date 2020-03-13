#!/bin/bash
# Invokes the build script in the repository 

echo "--> build-alarm-go.sh"

cmd="./adapter/build_adapter.sh"
echo "INFO: invoking build script: $cmd"
$cmd

echo "--> build-alarm-go.sh ends"
