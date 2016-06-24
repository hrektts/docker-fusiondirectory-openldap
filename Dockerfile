FROM osixia/openldap:1.1.3
MAINTAINER mps299792458@gmail.com

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 62B4981F \
 && echo 'deb http://repos.fusiondirectory.org/debian-jessie jessie main' \
       > /etc/apt/sources.list.d/fusiondirectory-stable-jessie.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
      --no-install-recommends \
      fusiondirectory-schema \
      fusiondirectory-plugin-argonaut-schema \
      fusiondirectory-plugin-autofs-schema \
      fusiondirectory-plugin-gpg-schema \
      fusiondirectory-plugin-mail-schema \
      fusiondirectory-plugin-personal-schema \
      fusiondirectory-plugin-ssh-schema \
      fusiondirectory-plugin-sudo-schema \
      fusiondirectory-plugin-systems-schema \
      fusiondirectory-plugin-weblink-schema \
      fusiondirectory-plugin-webservice-schema \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY insert_schema.sh /sbin/insert_schema.sh
RUN chmod 755 /sbin/insert_schema.sh

RUN sed -i "/# stop OpenLDAP/i /sbin/insert_schema.sh" /container/service/slapd/startup.sh
