#!/bin/sh

export LLDAP_NAMESPACE=lldap
export LLDAP_APP_NAME=lldap
export LLDAP_LDAP_PORT=3890
export LLDAP_ADMIN_PORT=17170
export LLDAP_DEBUG=true
export LLDAP_JWT_SECRET=thisisademopassword # update with your own secret
export LLDAP_LDAP_USER_PASS=demoadminpassword # update with your own secret
export LLDAP_BASE_DN="dc=example,dc=com" # set your own base DN for the LDAP hierarchy
export LLDAP_JWT_SECRET_B64=$(echo $LLDAP_JWT_SECRET | base64) 
export LLDAP_LDAP_USER_PASS_B64=$(echo $LLDAP_LDAP_USER_PASS | base64) 
export LLDAP_BASE_DN_B64=$(echo $LLDAP_BASE_DN | base64) 

oc new-project $LLDAP_NAMESPACE

envsubst < lldap-credentials.yaml > lldap-credentials.yaml-customized
envsubst < lldap-configmap.yaml > lldap-configmap.yaml-customized
envsubst < lldap-pvc.yaml > lldap-pvc.yaml-customized
envsubst < lldap-deployment.yaml > lldap-deployment.yaml-customized
envsubst < lldap-service.yaml > lldap-service.yaml-customized
envsubst < lldap-route-tls.yaml > lldap-route-tls.yaml-customized

oc apply -f lldap-credentials.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-configmap.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-pvc.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-deployment.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-service.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-route-tls.yaml-customized -n $LLDAP_NAMESPACE

export LLDAP_HOSTNAME=$(oc get svc $(echo $LLDAP_APP_NAME)-service -o go-template='{{.metadata.name}}.{{.metadata.namespace}}.svc.cluster.local{{println}}')

envsubst < sample-configs/ibm-software-hub.md > sample-configs/ibm-software-hub.md-customized
