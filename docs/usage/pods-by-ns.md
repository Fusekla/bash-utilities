# pods-by-ns.sh
Purpose of this script is to print out all present pods in K8S/OCP cluster with their status, optionally grouped by namespace

## Usage
Get full pods list for entire cluster
```bash
$ bin/pods-by-ns.sh
openshift-logging                                  cluster-logging-operator-6bcfb4f8dc-tw72n                                                         Running
openshift-logging                                  collector-5t5jw                                                                                   Running
openshift-logging                                  collector-8q8x7                                                                                   Running
openshift-logging                                  collector-8qpzn                                                                                   Running
openshift-logging                                  collector-n82w2                                                                                   Running
openshift-logging                                  collector-nrzrw                                                                                   Running
openshift-logging                                  collector-sz5kh                                                                                   Running
openshift-logging                                  collector-x8t8d                                                                                   Running
openshift-logging                                  collector-xh6mb                                                                                   Running
openshift-logging                                  elasticsearch-cdm-obdxp7wg-1-5ddf786859-wmmwx                                                     Running
openshift-logging                                  elasticsearch-cdm-obdxp7wg-2-85dd7d9bc4-ds8k6                                                     Running
openshift-logging                                  elasticsearch-cdm-obdxp7wg-3-5bfdf487cc-vghcw                                                     Running
openshift-logging                                  elasticsearch-im-app-29258850-6vqsn                                                               Succeeded
openshift-logging                                  elasticsearch-im-audit-29258850-fk96d                                                             Succeeded
openshift-logging                                  elasticsearch-im-infra-29258850-wxv56                                                             Succeeded
openshift-logging                                  kibana-7c484d966d-8n2kv                                                                           Running
...
```
Get summary pods count grouped by namespace
```bash
$ bin/pods-by-ns.sh --summary
      3 openshift-apiserver
      1 openshift-apiserver-operator
      3 openshift-authentication
      1 openshift-authentication-operator
      2 openshift-cloud-controller-manager
      1 openshift-cloud-controller-manager-operator
...
```
