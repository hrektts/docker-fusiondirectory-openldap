#!/bin/bash
set -e

BOOTSTRAPPED=/etc/ldap/slapd.d/bootstrapped
if [ -e ${BOOTSTRAPPED} ]; then
    exit 0
fi

IFS='.' read -a domain_elems <<< "${LDAP_DOMAIN}"
SUFFIX=""
TOP=""
for elem in "${domain_elems[@]}" ; do
    if [ "x${SUFFIX}" = x ] ; then
        SUFFIX="dc=${elem}"
        TOP="${elem}"
    else
        SUFFIX="${SUFFIX},dc=${elem}"
    fi
done

CN_ADMIN="cn=admin,ou=aclroles,${SUFFIX}"
UID_FD_ADMIN="uid=fd-admin,${SUFFIX}"
CN_ADMIN_BS64=$(echo -n ${CN_ADMIN} | base64 | tr -d '\n')
UID_FD_ADMIN_BS64=$(echo -n ${UID_FD_ADMIN} | base64 | tr -d '\n')
FD_ADMIN_PASSWORD=${FD_ADMIN_PASSWORD:-"adminpassword"}

touch /tmp/delete.ldif

if "${LDAP_READONLY_USER}"; then
    cat <<EOF >> /tmp/delete.ldif
dn: cn=${LDAP_READONLY_USER_USERNAME},${SUFFIX}
changetype: delete

EOF
fi

cat <<EOF >> /tmp/delete.ldif
dn: cn=admin,${SUFFIX}
changetype: delete

dn: ${SUFFIX}
changetype: delete

EOF

ldapmodify -x -D "cn=admin,${SUFFIX}" -w ${LDAP_ADMIN_PASSWORD} -f /tmp/delete.ldif
fusiondirectory-insert-schema

cat <<EOF > /tmp/base.ldif
dn: ${SUFFIX}
o: ${LDAP_ORGANISATION}
dc: ${TOP}
ou: ${TOP}
description: ${TOP}
objectClass: top
objectClass: dcObject
objectClass: organization
objectClass: gosaDepartment
objectClass: gosaAcl
gosaAclEntry: 0:subtree:${CN_ADMIN_BS64}:${UID_FD_ADMIN_BS64}

dn: cn=admin,${SUFFIX}
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword: ${LDAP_ADMIN_PASSWORD}

EOF

if "${LDAP_READONLY_USER}"; then
    cat <<EOF >> /tmp/base.ldif
dn: cn=${LDAP_READONLY_USER_USERNAME},${SUFFIX}
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: cn=${LDAP_READONLY_USER_USERNAME}
description: LDAP read only user
userPassword: ${LDAP_READONLY_USER_PASSWORD}

EOF
fi

ldapadd -x -D "cn=admin,${SUFFIX}" -w ${LDAP_ADMIN_PASSWORD} -f /tmp/base.ldif

cat <<EOF > /tmp/add.ldif
dn: uid=fd-admin,${SUFFIX}
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
cn: System Administrator
sn: Administrator
givenName: System
uid: fd-admin
userPassword: ${FD_ADMIN_PASSWORD}

dn: ou=aclroles,${SUFFIX}
objectClass: organizationalUnit
ou: aclroles

dn: cn=admin,ou=aclroles,${SUFFIX}
objectClass: top
objectClass: gosaRole
cn: admin
description: Gives all rights on all objects
gosaAclTemplate: 0:all;cmdrw

dn: cn=manager,ou=aclroles,${SUFFIX}
cn: manager
description: Give all rights on users in the given branch
objectClass: top
objectClass: gosaRole
gosaAclTemplate: 0:user/password;cmdrw,user/user;cmdrw,user/posixAccount;cmdrw

dn: cn=editowninfos,ou=aclroles,${SUFFIX}
cn: editowninfos
description: Allow users to edit their own information (main tab and posix use
  only on base)
objectClass: top
objectClass: gosaRole
gosaAclTemplate: 0:user/posixAccount;srw,user/user;srw

dn: ou=fusiondirectory,${SUFFIX}
objectClass: organizationalUnit
ou: fusiondirectory

dn: ou=tokens,ou=fusiondirectory,${SUFFIX}
objectClass: organizationalUnit
ou: tokens

dn: cn=config,ou=fusiondirectory,${SUFFIX}
fdTheme: default
fdTimezone: America/New_York
fusionConfigMd5: 7fd38d273a2f2e14c749467f4c38a650
fdSchemaCheck: TRUE
fdPasswordDefaultHash: ssha
fdListSummary: TRUE
fdModificationDetectionAttribute: entryCSN
fdLogging: TRUE
fdLdapSizeLimit: 200
fdLoginAttribute: uid
fdWarnSSL: TRUE
fdSessionLifeTime: 1800
fdEnableSnapshots: TRUE
fdSnapshotBase: ou=snapshots,${SUFFIX}
fdSslKeyPath: /etc/ssl/private/fd.key
fdSslCertPath: /etc/ssl/certs/fd.cert
fdSslCaCertPath: /etc/ssl/certs/ca.cert
fdCasServerCaCertPath: /etc/ssl/certs/ca.cert
fdCasHost: localhost
fdCasPort: 443
fdCasContext: /cas
fdAccountPrimaryAttribute: uid
fdCnPattern: %givenName% %sn%
fdStrictNamingRules: TRUE
fdMinId: 100
fdUidNumberBase: 1100
fdGidNumberBase: 1100
fdUserRDN: ou=people
fdGroupRDN: ou=groups
fdAclRoleRDN: ou=aclroles
fdIdAllocationMethod: traditional
fdDebugLevel: 0
fdShells: /bin/ash
fdShells: /bin/bash
fdShells: /bin/csh
fdShells: /bin/sh
fdShells: /bin/ksh
fdShells: /bin/tcsh
fdShells: /bin/dash
fdShells: /bin/zsh
fdShells: /sbin/nologin
fdShells: /bin/false
fdForcePasswordDefaultHash: FALSE
fdHandleExpiredAccounts: FALSE
fdForceSSL: FALSE
fdHttpAuthActivated: FALSE
fdCasActivated: FALSE
fdRestrictRoleMembers: FALSE
fdDisplayErrors: FALSE
fdLdapStats: FALSE
fdDisplayHookOutput: FALSE
fdAclTabOnObjects: FALSE
cn: config
fdOGroupRDN: ou=groups
fdForceSaslPasswordAsk: FALSE
fdDashboardNumberOfDigit: 3
fdDashboardPrefix: PC
fdDashboardExpiredAccountsDays: 15
objectClass: fusionDirectoryConf
objectClass: fusionDirectoryPluginsConf
objectClass: fdDashboardPluginConf
objectClass: fdPasswordRecoveryConf
fdPasswordRecoveryActivated: FALSE
fdPasswordRecoveryEmail: to.be@chang.ed
fdPasswordRecoveryValidity: 10
fdPasswordRecoverySalt: SomethingSecretAndVeryLong
fdPasswordRecoveryUseAlternate: FALSE
fdPasswordRecoveryMailSubject: [FusionDirectory] Password recovery link
fdPasswordRecoveryMailBody:: SGVsbG8sCgpIZXJlIGFyZSB5b3VyIGluZm9ybWF0aW9ucyA6I
 AogLSBMb2dpbiA6ICVzCiAtIExpbmsgOiAlcwoKVGhpcyBsaW5rIGlzIG9ubHkgdmFsaWQgZm9yID
 EwIG1pbnV0ZXMu
fdPasswordRecoveryMail2Subject: [FusionDirectory] Password recovery successful
fdPasswordRecoveryMail2Body:: SGVsbG8sCgpZb3VyIHBhc3N3b3JkIGhhcyBiZWVuIGNoYW5n
 ZWQuCllvdXIgbG9naW4gaXMgc3RpbGwgJXMu

dn: ou=locks,ou=fusiondirectory,${SUFFIX}
objectClass: organizationalUnit
ou: locks

dn: ou=snapshots,${SUFFIX}
objectClass: organizationalUnit
ou: snapshots

EOF

mkdir -p /etc/ldap/schema/fusiondirectory/modify
mv /etc/ldap/schema/fusiondirectory/rfc2307bis.schema \
   /etc/ldap/schema/fusiondirectory/modify/
fusiondirectory-insert-schema -i /etc/ldap/schema/fusiondirectory/*.schema
fusiondirectory-insert-schema -m /etc/ldap/schema/fusiondirectory/modify/*.schema
ldapadd -x -D "cn=admin,${SUFFIX}" -w ${LDAP_ADMIN_PASSWORD} -f /tmp/add.ldif

rm -rf /tmp/*
touch ${BOOTSTRAPPED}
