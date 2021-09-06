#!/bin/bash
set -e
trap 'catch $? $LINENO' ERR
catch() {
  echo "Error $1 occurred on $2"
}
set -euo pipefail

SCRIPT_PATH=$0
REAL_SCRIPT_PATH=$(readlink -f ${SCRIPT_PATH})
SCRIPT_DIR=$(dirname ${REAL_SCRIPT_PATH}})

read Xenv < <(x11docker --hostdisplay --gpu --showenv --quiet)
export $Xenv
export MAKERBOT_DEVICE=/dev/makerbot/$(ls /dev/makerbot/)

cd "${SCRIPT_DIR}"

docker-compose run --rm -d makerware || true
MAIN_CONTAINER_NAME=$(docker-compose ps | grep makerware-docker_makerware_run | awk '{ print $1; }')
docker-compose logs -f &
docker wait ${MAIN_CONTAINER_NAME} || true
docker-compose down -v || true
x11docker --cleanup