#!/bin/bash

set -e

name=""
os=""
arch=""
version=""

while getopts "n:o:a:v:h" opt; do
  case ${opt} in
    n)
      name="${OPTARG}"
      ;;
    o)
      os="${OPTARG}"
      ;;
    a)
      arch="${OPTARG}"
      ;;
    v)
      version="${OPTARG}"
      ;;
  esac
done

for required in "name" "os" "arch" "version"; do
  if [[ -z "${!required}" ]]; then
    echo "Required parameter was missing: \$${required}"
    exit 1
  fi
done

full_arch="${os}_${arch}"
binary="${name}_v${version}"

echo "==> Building the following binary for ${full_arch}: ${binary}"

output="build/${full_arch}/${binary}"
[[ -e "${output}" ]] && rm ${output}

commit_sha=$(git rev-parse HEAD)
date=$(date +%Y-%m-%dT%T%z)

GOOS=${os} GOARCH=${arch} go build -a \
  -ldflags "-X main.version=${version} -X main.commit=${commit_sha} -X main.date=${date}" \
  -o ${output}
