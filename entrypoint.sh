#!/bin/bash
set -e

echo ${ARTIFACT_KUBERNETES_CLUSTER} > /kube-config
echo "::set-output name=kube_config::/kube-config"
export KUBECONFIG=/kube-config

echo ${APPLICATION_ID}
echo ${IMAGE}

cat /kube-config | grep -v data | grep -v token

# GITHUB Actions only interpolate yaml or bash-in-yaml
# there's no way for this file to understant ${{ inputs.application_id }}
# so we pass it in as an environment variable instead

kubectl patch deployment ${APPLICATION_ID} -p '{"spec": {"template": {"spec": {"containers": [{"name": "${APPLICATION_ID}", "image": "${IMAGE}"}]}}}}'
