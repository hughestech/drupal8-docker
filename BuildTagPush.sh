#!/bin/bash

TAG=hughestech/opensocial


set -ex

PARENT_DIR=$(basename "${PWD%/*}")
CURRENT_DIR="${PWD##*/}"
IMAGE_NAME="$TAG"


REGISTRY="$(minishift openshift registry)"

minishift start --openshift-version=v1.5.0 --iso-url https://github.com/minishift/minishift-centos-iso/releases/download/v1.0.0/minishift-centos7.iso

eval $(minishift docker-env)
docker login -u developer -p $(oc whoami -t) ${REGISTRY}
docker build -t ${REGISTRY}/${IMAGE_NAME} --build-arg DRUPAL_INSTALL_DIR=/var/www/lightning --build-arg DOC_ROOT=/docroot  --build-arg COMPOSER_PROJECT=acquia/lightning-project .

docker tag  ${REGISTRY}/${IMAGE_NAME}          ${REGISTRY}/myproject
#docker push ${REGISTRY}/${IMAGE_NAME}
#docker tag  ${REGISTRY}/${IMAGE_NAME}:latest   ${REGISTRY}/${IMAGE_NAME}
oc whoami -t
docker login -u developer -p $(oc whoami -t)   ${REGISTRY}
echo "minishift ip is "
minishift ip

docker push ${REGISTRY}/myproject
