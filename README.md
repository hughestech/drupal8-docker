* Drupal 8 for OpenShift v3 with WebDAV for data transfer.

To install the templates run  `oc create -f <templatename>`.

## Build

Currently the following places need to be manually changed, based on installation directory:

* config/default.conf
* entrypoint.sh

eg,

 `root   /var/www/lightning/docroot;`

### OpenSocial

 `docker build . --build-arg DRUPAL_INSTALL_DIR=/var/www/opensocial --build-arg DOC_ROOT=/html --build-arg COMPOSER_PROJECT=goalgorilla/social_template:dev-master Dockerfile`

### Lightning

  `docker build . --build-arg DRUPAL_INSTALL_DIR=/var/www/lightning --build-arg DOC_ROOT=/docroot  --build-arg COMPOSER_PROJECT=acquia/lightning-project
`
RUN sed -i "s/drupaldir/${DRUPAL_INSTALL_DIR}${DOC_ROOT}/g" /workdir/entrypoint.sh
RUN sed -i 's/drupaldir/${DRUPAL_INSTALL_DIR}${DOC_ROOT}/g' /workdir/entrypoint.sh
