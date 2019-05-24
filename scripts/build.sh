#!/bin/bash

set -e
set -x

for os in "darwin" "linux" "windows"; do
  arch="amd64"
  full_arch="${os}_${arch}"
  output="build/${full_arch}/terraform-provider-k8s"
  GOOS=${os} GOARCH=${arch} go build -v -o ${output}
done
