# extract-images.sh
Purpose of this script is to collect images used by all **Deployments** across entire cluster. User has an option to include namespace where image resides in the output. 
It does **not** collect images used by *initContainers*, *deamonSets* or *statefulSets*. 

## Usage
### Without namespaces
```bash
$ bin/extract-images.sh |grep redhat | head
registry.redhat.io/openshift-logging/cluster-logging-rhel9-operator@sha256:54054faf0d2f375dd6d7fc7929a2dbb529508e1b3c004a56fc97c2a682d16be2
registry.redhat.io/openshift-logging/elasticsearch-proxy-rhel9@sha256:b26d2218aa6b1efea83a1717d62f81009c97e8082434b918937c609f5cdab912
registry.redhat.io/openshift-logging/elasticsearch-rhel9-operator@sha256:78ffdf26b40a000d06eddfa4f66fdca9a11dc21c82a3492eac7cb9f4338dfcf3
registry.redhat.io/openshift-logging/elasticsearch6-rhel9@sha256:8d603100978c655020a8f4d81c527162348f468d93989edbc00463b8297fb8a5
registry.redhat.io/openshift-logging/kibana6-rhel8@sha256:a2c200667738fdb079ba11ed3b0df3c5901373428d5e560bc1efea9d5e1ddd67
```
### With namespaces
```bash
$ bin/extract-images.sh --with-ns |grep openshift-logging | head
openshift-logging quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:bcc98dd2e2278730b5ed9d8b8365524df372064ab5c3fc002d6193c7bdbb1e1b
openshift-logging registry.redhat.io/openshift-logging/cluster-logging-rhel9-operator@sha256:54054faf0d2f375dd6d7fc7929a2dbb529508e1b3c004a56fc97c2a682d16be2
openshift-logging registry.redhat.io/openshift-logging/elasticsearch-proxy-rhel9@sha256:b26d2218aa6b1efea83a1717d62f81009c97e8082434b918937c609f5cdab912
openshift-logging registry.redhat.io/openshift-logging/elasticsearch6-rhel9@sha256:8d603100978c655020a8f4d81c527162348f468d93989edbc00463b8297fb8a5
openshift-logging registry.redhat.io/openshift-logging/kibana6-rhel8@sha256:a2c200667738fdb079ba11ed3b0df3c5901373428d5e560bc1efea9d5e1ddd67
openshift-operators-redhat registry.redhat.io/openshift-logging/elasticsearch-rhel9-operator@sha256:78ffdf26b40a000d06eddfa4f66fdca9a11dc21c82a3492eac7cb9f4338dfcf3
```