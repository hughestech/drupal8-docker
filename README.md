* Drupal 8 for OpenShift v3 with WebDAV for data transfer.

To install the templates run  `oc create -f <templatename>`.

## Build

### OpenSocial

 `docker build . --build-arg DRUPAL_INSTALL_DIR=/var/www/opensocial --build-arg DOC_ROOT=/html --build-arg COMPOSER_PROJECT=goalgorilla/social_template:dev-master Dockerfile`

### Lightning

  `docker build . --build-arg DRUPAL_INSTALL_DIR=/var/www/lighning --build-arg DOC_ROOT=/docroot  --build-arg COMPOSER_PROJECT=acquia/lightning-project
`
