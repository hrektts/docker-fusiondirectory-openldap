#!/bin/bash -e

fusiondirectory-insert-schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/argonaut-fd.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/autofs-fd-conf.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/gpg-fd.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/pgp-remte-prefs.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/pgp-keyserver.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/pgp-recon.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/mail-fd.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/mail-fd-conf.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/personal-fd.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/personal-fd-conf.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/openssh-lpk.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/sudo.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/sudo-fd-conf.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/systems-fd-conf.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/service-fd.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/systems-fd.schema
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/webservice-fd-conf.schema
