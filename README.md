# docker-fusiondirectory-openldap

Dockerfile to build a [OpenLDAP](http://www.openldap.org/) container image that
includes the [FusionDirectory](https://www.fusiondirectory.org/) schemas.

[![Travis Build Status](https://travis-ci.org/Fekide/docker-fusiondirectory-openldap.svg?branch=master)](https://travis-ci.org/Fekide/docker-fusiondirectory-openldap)

## Quick Start

You can launch the image using the docker command:

``` shell
docker run --name ldap -p 389:389 \
  -e LDAP_ORGANISATION="Example Organization" \
  -e LDAP_DOMAIN="example.org" \
  -e LDAP_ADMIN_PASSWORD="password" \
  -e FD_ADMIN_PASSWORD="fdadminpwd" \
  -d hrektts/fusiondirectory-openldap:latest
```

## Environment Variables

|      Variable       | Function                                                  |       default |
| :-----------------: | --------------------------------------------------------- | ------------: |
|  LDAP_ORGANISATION  | Name of your Organisation                                 |  Example Inc. |
|     LDAP_DOMAIN     | Domain of your Organisation                               |   example.org |
| LDAP_ADMIN_PASSWORD | Password for the LDAP Admin  (cn=admin,dc=example,dc=org) |         admin |
|  FD_ADMIN_PASSWORD  | Password for the FusionDirectory Admin (fd-admin)         | adminpassword |

## References

More Environment variables and information here:
[osixia/docker-openldap](https://github.com/osixia/docker-openldap)
