# Configuring LLDAP as an Identity Provider in IBM Software Hub

You can set up IBM Software Hub to use LLDAP as an identity provider by following
the instructions in the IBM
[documentation](https://www.ibm.com/docs/en/software-hub/5.2.x?topic=users-connecting-your-identity-provider).

## Sample default configuration if the Identity Management Service is enabled

Per IBM Software Hub
[documentation](https://www.ibm.com/docs/en/software-hub/5.2.x?topic=users-connecting-your-identity-provider#ldap__iam__title__1):

1. Log in to the IBM Software Hub client.
2. From the menu, click __Administration > Identity providers__.
3. Click __New connection__.
4. Select __LDAP__. Then, click __Next__.
   Follow the guidance in
   [Configuring LDAP connection](https://www.ibm.com/docs/en/cloud-paks/foundational-services/4.0.0?topic=users-configuring-ldap-connection)
   or use the following default values:

- __Connection name__: `LLDAP`
- __Server type__: `Custom`
- __Case insensitive user search__: `True`
- __Base DN__: `ou=people,dc=example,dc=com`
- __Bind DN__: `cn=admin,ou=people,dc=example,dc=com`
- __Bind DN password__: `$LLDAP_LDAP_USER_PASS`
- __Server URL__: `$LLDAP_HOSTNAME`
- __User filter__: `(&(uid=%v)(objectClass=person))`
- __User ID map__: `*:uid`
