#!/bin/bash
set -e

mkdir -p ${HOME}/.kube
echo ${ARTIFACT_KUBERNETES_CLUSTER} > ${HOME}/.kube/config
echo "::set-output name=kube_config::${HOME}/.kube/config"
# GITHUB Actions only interpolate yaml or bash-in-yaml
# there's no way for this file to understant ${{ inputs.application_id }}
# so we pass it in as an environment variable instead

kubectl patch deployment ${APPLICATION_ID} -p '{"spec": {"template": {"spec": {"containers": [{"name": "${APPLICATION_ID}", "image": "${IMAGE}"}]}}}}'
