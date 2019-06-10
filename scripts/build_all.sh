#!/bin/bash

set -e

name="terraform-provider-k8s"
os=""
arch=""
version=""

while getopts "n:o:a:v:h" opt; do
  case ${opt} in
    n)
      name="${OPTARG}"
      ;;
    v)
      version="${OPTARG}"
      ;;
  esac
done

for required in "name" "version"; do
  if [[ -z "${!required}" ]]; then
    echo "Required parameter was missing: \$${required}"
    exit 1
  fi
done

for os in "darwin" "linux" "windows"; do
  for arch in "386" "amd64"; do
    full_arch="${os}_${arch}"
    binary="${name}_v${version}"

    echo "==> Building the following binary for ${full_arch}: ${binary}"

    output="build/${full_arch}/${binary}"
    [[ -e "${output}" ]] && rm ${output}
    GOOS=${os} GOARCH=${arch} go build -v -ldflags "-X main.VERSION=${version}" -o ${output}
  done
done
