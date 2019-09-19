#!/bin/bash -e
set -e

if [ ! -e "$FIRST_START_DONE" ]; then

    CN_ADMIN="cn=admin,ou=aclroles,${LDAP_BASE_DN}"
    UID_FD_ADMIN="uid=${FD_ADMIN_USERNAME},${LDAP_BASE_DN}"
    CN_ADMIN_BS64=$(echo -n ${CN_ADMIN} | base64 | tr -d '\n')
    UID_FD_ADMIN_BS64=$(echo -n ${UID_FD_ADMIN} | base64 | tr -d '\n')

    LDAP_ADMIN_PASSWORD_HASH=$(slappasswd -s $LDAP_ADMIN_PASSWORD)
    FD_ADMIN_PASSWORD_HASH=$(slappasswd -s $FD_ADMIN_PASSWORD)

    fusiondirectory-insert-schema
    fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/*.schema
    fusiondirectory-insert-schema -m /etc/ldap/schema/fusiondirectory/modify/*.schema

    ldapmodify -x -D "cn=admin,${LDAP_BASE_DN}" -w ${LDAP_ADMIN_PASSWORD} -f /var/fusiondirectory/bootstrap/ldif/modify.ldif
    ldapadd -x -D "cn=admin,${LDAP_BASE_DN}" -w ${LDAP_ADMIN_PASSWORD} -f /var/fusiondirectory/bootstrap/ldif/add.ldif

    rm -rf /tmp/*
fi
