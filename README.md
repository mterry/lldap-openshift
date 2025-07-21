# Using the Light LDAP (LLDAP) implementation for authentication on OpenShift

LLDAP homepage: https://github.com/nitnelave/lldap

## About

For testing purposes you can run the LLDAP container on OpenShift and use the
container as a LDAP authentication backend.

Thanks to nitnelave for the changing LLDAP to get it authenticating with SUSE
Rancher (see https://github.com/nitnelave/lldap/issues/432), and thanks to
Evantage-WS for building the original Kubernetes version of this implementation
(see https://github.com/Evantage-WS/lldap-kubernetes).

## Login to OpenShift and create new project

Set your project namespace as an environment variable:

```
export LLDAP_NAMESPACE=lldap # in which namespace the lldap container will be installed, always use lowercase
```

Login to OpenShift with your administrator account credentials:

```
oc login \
   --token=<OCP admin API key> \
   --server=<OCP API URL>
```

Create a new project to contain all the LLDAP components:

```
oc new-project lldap
```

## Create secret LLDAP credentials

The LLDAP container will be using these secrets. The pod will not boot
successfully without these credentials set within an OpenShift Secret.

```
export LLDAP_JWT_SECRET=$(echo "thisisademopassword" | base64) # update with your own secret
export LLDAP_LDAP_USER_PASS=$(echo "demoadminpassword" | base64) # update with your own admin password
export LLDAP_BASE_DN=$(echo "dc=example,dc=com" | base64) # set your own base DN for the LDAP hierarchy
```

Once the session variables are set, either create the OpenShift secret via the
CLI or by updating `lldap-credentials.yaml`.

### Create the secrets from environment variables

```
oc create secret generic lldap-credentials \
  --from-literal=lldap-jwt-secret=${LLDAP_JWT_SECRET} \
  --from-literal=lldap-ldap-user-pass=${LLDAP_LDAP_USER_PASS} \
  --from-literal=base-dn=${LLDAP_BASE_DN} \
  -n ${LLDAP_NAMESPACE}
```

### Create the secrets by updating and applying the YAML

```
envsubst < lldap-credentials.yaml > lldap-credentials.yaml-customized
oc apply -f lldap-credentials.yaml-customized -n $LLDAP_NAMESPACE
```

## Apply the YAML configurations

### Configuration layout

- `lldap-credentials.yaml`: OpenShift secrets for LLDAP configuration
- `lldap-configmap.yaml`: Configuration environment variables for LLDAP
- `lldap-pvc.yaml`: Persistent Volume Claim for LLDAP
  - pre-configured for RWO on cephfs
- `lldap-deployment.yaml`: Deployment definition for LLDAP
  - using `nitnelave/lldap:latest-alpine-rootless` Docker Hub image
- `lldap-service.yaml`: Service definition for LLDAP exposing
  - LDAP on port 3890
  - admin web frontend on 17170
- `lldap-route.yaml`: Route definition for LLDAP exposing the LDAP admin web
  console

### Update YAML templates

Using `envsubst`, update the YAML templates within the repository with the
values assigned to the environment variables set previously.

```
envsubst < lldap-configmap.yaml > lldap_configmap.yaml-customized
envsubst < lldap-pvc.yaml > lldap_pvc.yaml-customized
envsubst < lldap-deployment.yaml > lldap_deployment.yaml-customized
envsubst < lldap-service.yaml > lldap_service.yaml-customized
envsubst < lldap-route.yaml > lldap_route.yaml-customized
```

### Apply updated YAMLs

Install LLDAP on the OpenShift cluster by applying the customized YAML templates
to the cluster.

```
oc apply -f lldap-configmap.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-pvc.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-deployment.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-service.yaml-customized -n $LLDAP_NAMESPACE
oc apply -f lldap-route.yaml-customized -n $LLDAP_NAMESPACE
```

It will take maybe a minute or so, after pulling the image it will be up and running.

Your LLDAP container is then ready for accepting LDAP requests on port 3890
through the internal cluster network. As it will be necessary for configuring
LDAP access for cluster services, take note of the deployed service's hostname from
the OCP web console, or use the following command to find the hostname and store
it as an environment variable.

```
export LLDAP_HOSTNAME=$(oc get svc lldap-service -o go-template='{{.metadata.name}}.{{.metadata.namespace}}.svc.cluster.local{{println}}')
```

## Accessing the UI

To add user and groups to LLDAP, you can use the web admin UI included in LLDAP
and exposed through the deployed route. Get the route URL from the OCP web
console, or use the following CLI command to find the URL:

```
oc get routes -n $LLDAP_NAMESPACE
```

In your browser go to the URL you retrieved in the step before. Login with `admin`
and use the password set in the environment variables previously.

For creating user and groups, please look at the LLDAP documentation at https://github.com/nitnelave/lldap

## Connecting LLDAP to consumer services

For creating connections to your new LLDAP implementation, see the example
configs in the [core LLDAP repository]
(https://github.com/lldap/lldap/tree/main/example_configs) or use example
configurations stored in `sample-configs/` in this repository. Example
configurations in this repository use the environment variables set in this
installation guide to simplify deployment, and you can generate customized
configuration guides by using:

```
envsubst < sample-configs/ibm-software-hub.md > sample-configs/ibm-software-hub.md-customized
```

## TODO

- Update Helm charts
