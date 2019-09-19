FROM osixia/openldap:1.1.11
MAINTAINER Feki.de e.V. "it@feki.de"
LABEL version="1.1.11-1.3-1"

ADD bootstrap /var/fusiondirectory/bootstrap
ADD certs /container/service/slapd/assets/certs
ADD environment /container/environment/01-custom

ARG FUSIONDIRECTORY_VERSION=1.3-1

RUN apt-key adv --keyserver keys.gnupg.net --receive-keys D744D55EACDA69FF \
 && (echo "deb http://repos.fusiondirectory.org/fusiondirectory-current/debian-stretch stretch main"; \
     echo "deb http://repos.fusiondirectory.org/fusiondirectory-extra/debian-stretch stretch main") \
    > /etc/apt/sources.list.d/fusiondirectory-stretch.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    fusiondirectory-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-argonaut-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-autofs-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-gpg-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-mail-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-postfix-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-ssh-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-sudo-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-systems-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-weblink-schema=${FUSIONDIRECTORY_VERSION} \
    fusiondirectory-plugin-webservice-schema=${FUSIONDIRECTORY_VERSION} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY init.sh /sbin/init.sh
RUN chmod 755 /sbin/init.sh
RUN sed -i "/# stop OpenLDAP/i /sbin/init.sh" /container/service/slapd/startup.sh
