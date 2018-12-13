#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_NAME=$(basename "$CURRENT_DIR")

echo "Will share this folder:$REPO_NAME with the docker container".
echo "stop container:" && docker stop ci_xenial_robot || true
echo "remove container:" && docker rm ci_xenial_robot || true
echo "rerun container ci_xenial_robot:"
cd ${CURRENT_DIR} && docker run -d -it --name ci_xenial_robot -v $(pwd):/home/robot/${REPO_NAME} local_xenial_robot # read only share
docker exec -u robot -it ci_xenial_robot /bin/bash "sudo chown robot:robot -R /home/robot"
docker exec -u robot -it ci_xenial_robot /bin/bash
