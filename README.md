* Drupal 8 for OpenShift v3 with WebDAV for data transfer.

To install the templates run  `oc create -f <templatename>`.

## Build

### OpenSocial

 `docker build --build-arg DRUPAL_INSTALL_DIR=/var/www/opensocial DOC_ROOT=/html COMPOSER_PROJECT=goalgorilla/social_template:dev-master`

### Lightning

  `docker build --build-arg DRUPAL_INSTALL_DIR=/var/www/lighning DOC_ROOT=/docroot  COMPOSER_PROJECT=acquia/lightning-project`
