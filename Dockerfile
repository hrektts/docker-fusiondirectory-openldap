FROM osixia/openldap:1.1.3
MAINTAINER mps299792458@gmail.com

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
      --no-install-recommends \
      fusiondirectory-schema \
      fusiondirectory-plugin-autofs-schema \
      fusiondirectory-plugin-gpg-schema \
      fusiondirectory-plugin-mail-schema \
      fusiondirectory-plugin-ssh-schema \
      fusiondirectory-plugin-sudo-schema \
      fusiondirectory-plugin-systems-schema \
      fusiondirectory-plugin-weblink-schema \
      fusiondirectory-plugin-webservice-schema \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i "/# stop OpenLDAP/i fusiondirectory-insert-schema" /container/service/slapd/startup.sh
