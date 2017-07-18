* Drupal 8 for OpenShift v3 with WebDAV for data transfer.

To install the templates run  `oc create -f <templatename>`.

## Build

Currently the following places need to be manually changed, based on installation directory:

* config/default.conf
* entrypoint.sh

eg,

 `root   /var/www/lightning/docroot;`

### OpenSocial

 `docker build . --build-arg DRUPAL_INSTALL_DIR=/var/www/opensocial --build-arg DOC_ROOT=/html --build-arg COMPOSER_PROJECT=hughestech/social_template:master Dockerfile`

### Lightning

  `docker build . --build-arg DRUPAL_INSTALL_DIR=/var/www/lightning --build-arg DOC_ROOT=/docroot  --build-arg COMPOSER_PROJECT=acquia/lightning-project Dockerfile`

RUN sed -i "s/drupaldir/${DRUPAL_INSTALL_DIR}${DOC_ROOT}/g" /workdir/entrypoint.sh
RUN sed -i 's/drupaldir/${DRUPAL_INSTALL_DIR}${DOC_ROOT}/g' /workdir/entrypoint.sh


oc volume dc --all
oc volume dc/nginx --add --claim-size 512M --mount-path /usr/share/nginx/html --name downloads

## Use MiniShift

Run `eval $(minishift docker-env)` to use the docker engine that comes with Minishift.
Then run the docker build commands above.

 `minishift start --insecure-registry IP:5000 --insecure-registry 172.30.0.0/16`

 `$ minishift start --openshift-version=v1.5.0
$ eval $(minishift docker-env)`

Login with ` oc login`

       `docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)`
`
$ OPENSHIFT_TOKEN=$(oc whoami -t)
$ docker login -u developer -p ${OPENSHIFT_TOKEN} <ip address>:5000 `

Find the ip address with     `minishift ip`.
