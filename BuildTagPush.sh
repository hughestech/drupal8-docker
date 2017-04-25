#!/bin/bash

TAG=hughestech/lightning


set -ex

PARENT_DIR=$(basename "${PWD%/*}")
CURRENT_DIR="${PWD##*/}"
IMAGE_NAME="$TAG"


REGISTRY="$(minishift openshift registry)"

eval $(minishift docker-env)
docker login -u developer -p $(oc whoami -t) ${REGISTRY}
docker build -t ${REGISTRY}/${IMAGE_NAME}  --build-arg DRUPAL_INSTALL_DIR=/var/www/lightning --build-arg DOC_ROOT=/docroot  --build-arg COMPOSER_PROJECT=acquia/lightning-project .

docker tag  ${REGISTRY}/${IMAGE_NAME}         ${REGISTRY}/${IMAGE_NAME}:latest
#docker push ${REGISTRY}/${IMAGE_NAME}
docker tag  ${REGISTRY}/${IMAGE_NAME}:latest  ${REGISTRY}/${IMAGE_NAME}
docker login -u developer -p $(oc whoami -t) ${REGISTRY}
echo "minishift ip is "
minishift ip
docker push ${REGISTRY}/${IMAGE_NAME}
