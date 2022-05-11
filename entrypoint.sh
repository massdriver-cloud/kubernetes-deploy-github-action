#!/bin/bash
set -e

CERTIFICATE_AUTHORITY_DATA=$(echo $ARTIFACT_KUBERNETES_CLUSTER | jq -r '.authentication.cluster."certificate-authority-data"')
CLUSTER_SERVER=$(echo $ARTIFACT_KUBERNETES_CLUSTER | jq -r '.authentication.cluster.server')
TOKEN=$(echo $ARTIFACT_KUBERNETES_CLUSTER | jq -r '.authentication.user.token')

sed "s/<certificate-authority-data>/${CERTIFICATE_AUTHORITY_DATA}/" /kube-config-template > kube-config.tmp-0
sed "s|<cluster-server>|${CLUSTER_SERVER}|" kube-config.tmp-0 > kube-config.tmp-1
sed "s/<user-token>/${TOKEN}/" kube-config.tmp-1 > kube-config

rm kube-config.tmp-0 kube-config.tmp-1

# output the path to the kubeconfig file so downstream steps can use it.
echo "::set-output name=kube_config::kube-config"
