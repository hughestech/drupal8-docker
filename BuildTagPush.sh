#!/bin/bash

TAG=hughestech/opensocial


set -ex

PARENT_DIR=$(basename "${PWD%/*}")
CURRENT_DIR="${PWD##*/}"
IMAGE_NAME="$TAG"






minishift start --iso-url centos
#minishift start



REGISTRY="$(minishift openshift registry)"

eval $(minishift docker-env)
docker login -u developer -p $(oc whoami -t) ${REGISTRY}
docker build -t ${REGISTRY}/${IMAGE_NAME} --build-arg DRUPAL_INSTALL_DIR=/var/www/opensocial --build-arg DOC_ROOT=/html  --build-arg COMPOSER_PROJECT=hughestech/social_template:dev-master .

docker tag  ${REGISTRY}/${IMAGE_NAME}          ${REGISTRY}/myproject
#docker push ${REGISTRY}/${IMAGE_NAME}
#docker tag  ${REGISTRY}/${IMAGE_NAME}:latest   ${REGISTRY}/${IMAGE_NAME}
oc whoami -t
docker login -u developer -p $(oc whoami -t)   ${REGISTRY}
echo "minishift ip is "
minishift ip

docker push ${REGISTRY}/myproject
