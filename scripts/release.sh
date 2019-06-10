#!/bin/bash

set -e

SOURCE="${BASH_SOURCE[0]}"
while [ -h "${SOURCE}" ]; do
  DIR="$(cd -P "$( dirname "${SOURCE}" )" >/dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "${SOURCE}")"
  [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
done
DIR="$(cd -P "$(dirname "${SOURCE}")" >/dev/null 2>&1 && pwd)"

name=""
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

release_folder="dist"

for file in $(find build/ -type f); do
  IFS="/" read -ra path_parts <<< "${file}"
  binary=$(basename ${file})
  arch=${path_parts[2]}

  echo "==> Releasing the following binary for ${arch}: ${binary}"
  target_folder="${release_folder}/${arch}"
  mkdir -p ${target_folder}

  tar -C "build/${arch}" -czvf "${target_folder}/${binary}.tar.gz" ${binary}
done
