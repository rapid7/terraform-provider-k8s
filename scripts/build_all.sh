#!/bin/bash

for os in "darwin" "linux"; do
  for arch in "386" "amd64"; do
    GOOS=${os} GOARCH=${arch} go build
    mkdir -p build/${os}_${arch}
    mv terraform-provider-k8s build/${os}_${arch}
  done
done