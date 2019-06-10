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
source="build/${full_arch}/${binary}"
output="${HOME}/.terraform.d/plugins/${full_arch}"

echo "==> Installing the following binary for ${full_arch} @ ${output}: ${binary}"

mkdir -p "${output}"
cp "${source}" "${output}/${binary}"
ls -lhotr ${output}
