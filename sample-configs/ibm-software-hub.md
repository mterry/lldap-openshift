# Configuring LLDAP as an Identity Provider in IBM Software Hub
## Sample default configuration

- __Connection name__: `LLDAP`
- __Server type__: `Custom`
- __Case insensitive user search__: `True`
- __Base DN__: `ou=people,dc=example,dc=com`
- __Bind DN__: `cn=admin,ou=people,dc=example,dc=com`
- __Bind DN password__: `$LLDAP_LDAP_USER_PASS`
- __Server URL__: `$LLDAP_HOSTNAME`
- __User filter__: `(&(uid=%v)(objectClass=person))`
- __User ID map__: `*:uid`
