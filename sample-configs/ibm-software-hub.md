# Configuring LLDAP as an Identity Provider in IBM Software Hub

You can set up IBM Software Hub to use LLDAP as an identity provider by following
the instructions in the IBM
[documentation](https://www.ibm.com/docs/en/software-hub/5.2.x?topic=users-connecting-your-identity-provider).


## Sample default configuration if the embedded LDAP integration is enabled

Per IBM Software Hub
[documentation](https://www.ibm.com/docs/en/software-hub/5.2.x?topic=users-connecting-your-identity-provider#ldap__no-iam__title__1):

1. Log in to the IBM Software Hub web client.
2. From the menu, click __Administration > Access control__.
3. Click __LDAP configuration__.
4. In the __LDAP server information__ section, provide the following information
   about your LDAP server:

   - __LDAP protocol__: `ldap://`
   - __LDAP hostname__: `$LLDAP_HOSTNAME`
   - __LDAP port__: `3890`
   - __User search base__: `ou=people,dc=example,dc=com`
   - __User search field__: `displayname`
   - __Domain search user__: `cn=admin,ou=people,dc=example,dc=com`
   - __Domain search password__: `$LLDAP_LDAP_USER_PASS`
   - __Email__: `mail`

5. Test the connection with a previously configured username and password

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
