#!/usr/bin/env bats

@test "initialize" {
    run docker run --label bats-type="test" -p 389:389 -p 636:636 \
        -e LDAP_ORGANISATION="Example Organization" \
        -e LDAP_DOMAIN="example.org" \
        -e LDAP_ADMIN_PASSWORD="adminpwd" \
        -e LDAP_CONFIG_PASSWORD="configpwd" \
        -e LDAP_READONLY_USER=true \
        -e LDAP_READONLY_USER_USERNAME="readonly" \
        -e LDAP_READONLY_USER_PASSWORD="readonlypwd" \
        -e FD_ADMIN_PASSWORD="fdadminpwd" \
        -d hrektts/fusiondirectory-openldap:latest
    [ "${status}" -eq 0 ]
}

@test "test" {
    BASE_DN=dc=example,dc=org

    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b cn=admin,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b cn=readonly,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b ou=aclroles,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b cn=admin,ou=aclroles,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b cn=manager,ou=aclroles,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b cn=editowninfos,ou=aclroles,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b ou=fusiondirectory,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b ou=tokens,ou=fusiondirectory,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b cn=config,ou=fusiondirectory,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b ou=locks,ou=fusiondirectory,${BASE_DN}
    [ "${status}" -eq 0 ]
    run ldapsearch -LLL -h localhost -D cn=admin,${BASE_DN} -w adminpwd \
        -b ou=snapshots,${BASE_DN}
    [ "${status}" -eq 0 ]

    run ldapwhoami -x -h localhost -D uid=fd-admin,${BASE_DN} -w fdadminpwd
    [ "${status}" -eq 0 ]
}

@test "cleanup" {
    CIDS=$(docker ps -q --filter "label=bats-type")
    if [ ${#CIDS[@]} -gt 0 ]; then
        run docker stop ${CIDS[@]}
        run docker rm ${CIDS[@]}
    fi
}
