#!/bin/bash

set -e

SOURCE="${BASH_SOURCE[0]}"
while [ -h "${SOURCE}" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$(cd -P "$( dirname "${SOURCE}" )" >/dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "${SOURCE}")"
  # if ${SOURCE} was a relative symlink, we need to resolve it relative
  # to the path where the symlink file was located
  [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
done
DIR="$(cd -P "$(dirname "${SOURCE}")" >/dev/null 2>&1 && pwd)"

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
    ${DIR}/build.sh -n ${name} -o ${os} -a ${arch} -v ${version}
  done
done
