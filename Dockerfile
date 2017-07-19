FROM wodby/drupal-php:7.1
ARG DRUPAL_VERSION=8.3.0
ARG PHP_VERSION=8.3.0
ARG DRUPAL_INSTALL_DIR=/var/www/opensocial
ARG DOC_ROOT=/html
ARG COMPOSER_PROJECT=hughestech/social_template:dev-master

RUN set -xe && \



    apk add --update nginx





# Composer for Sabre installation
ARG COMPOSER_VERSION=1.4.2
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}




# Install Drupal project
RUN composer create-project ${COMPOSER_PROJECT} ${DRUPAL_INSTALL_DIR} --no-interaction --stability dev
RUN mkdir /var/www/webdav
RUN cp ${DRUPAL_INSTALL_DIR}${DOC_ROOT}/sites/default/default.settings.php ${DRUPAL_INSTALL_DIR}${DOC_ROOT}/sites/default/settings.php

# Verify that Drush works
RUN drush status

# WebDAV configuration
#RUN apt-get install -y apache2-utils
#RUN mkdir -p /var/www/webdav && mkdir -p /var/www/webdav/locks && chmod -R 777 /var/www/webdav/locks
#ADD config/webdav.conf /etc/nginx/conf.d/webdav.conf
#ADD sabre/index.php /var/www/webdav/index.php

# Sabre with composer
RUN cd /var/www/webdav && composer require sabre/dav ~3.2.2 && composer update sabre/dav && cd

# Add configuration files
ADD config/default.conf /etc/nginx/conf.d/default.conf
#RUN rm -rf /etc/nginx/conf.d/default.conf && ln -s /volume/conf/default.conf /etc/nginx/conf.d/default.conf

ADD entrypoint.sh /workdir/entrypoint.sh
#TODO - should use vairables
#RUN sed -i 's/drupaldir/${DRUPAL_INSTALL_DIR}${DOC_ROOT}/g' /workdir/entrypoint.sh

RUN mkdir /workdir/drupal-config && chmod 777 /workdir/drupal-config
ADD config/drupal-cache-config/* /workdir/drupal-config/

RUN mkdir /volume && chmod 777 /volume
#RUN rm -rf /var/www/drupal/themes/ && rm -rf /var/www/drupal/modules/ && rm -rf /var/www/drupal/sites/default
RUN ln -s /volume/themes/     ${DRUPAL_INSTALL_DIR}${DOC_ROOT}/themes
RUN ln -s /volume/modules/    ${DRUPAL_INSTALL_DIR}${DOC_ROOT}/modules
RUN ln -s /volume/default/    ${DRUPAL_INSTALL_DIR}${DOC_ROOT}/default
RUN ln -s /volume/libraries/  ${DRUPAL_INSTALL_DIR}${DOC_ROOT}/libraries
#RUN rm -rf /var/www/drupal/robots.txt && ln -s /volume/robots.txt /var/www/drupal/robots.txt

ADD config/nginx.conf /etc/nginx/nginx.conf



RUN chown -R 104:0 /var/www && chmod -R g+rw /var/www && \
    chmod a+x /workdir/entrypoint.sh && chmod g+rw /workdir

VOLUME ["/volume"]

# Additional CA certificate bundle (Mozilla)
ADD mailchimp-ca.sh /workdir/mailchimp-ca.sh
RUN chmod a+x /workdir/mailchimp-ca.sh && bash /workdir/mailchimp-ca.sh
RUN update-ca-certificates



# Install jsmin php extension
#RUN git clone -b feature/php7 https://github.com/sqmk/pecl-jsmin.git /workdir/pecl-jsmin
#RUN (cd /workdir/pecl-jsmin && phpize && ./configure && make install clean)
#RUN touch /etc/php/7.0/cli/conf.d/20-jsmin.ini && echo 'extension="jsmin.so"' >> /etc/php/7.0/cli/conf.d/20-jsmin.ini
#RUN echo 'extension="jsmin.so"' >> /etc/php/7.0/fpm/php.ini

# PHP max upload size
#RUN sed -i '/upload_max_filesize/c\upload_max_filesize = 250M' /etc/php/7.0/fpm/php.ini
#RUN sed -i '/post_max_size/c\post_max_size = 250M' /etc/php/7.0/fpm/php.ini

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log


RUN set -xe && \
  groupadd -g 107 nginx \
  && useradd -u 104 -g 107 -m -s /bin/bash nginx \
  && mkdir -p /run/nginx /var/cache/nginx \
  && /usr/libexec/fix-permissions /run/nginx \
  && /usr/libexec/fix-permissions /var/cache/nginx \
  && /usr/libexec/fix-permissions /var/lib/nginx \
  && /usr/libexec/fix-permissions /etc/nginx \
  && /usr/libexec/fix-permissions /var/log/nginx

EXPOSE 5000
EXPOSE 5005

USER 100104
