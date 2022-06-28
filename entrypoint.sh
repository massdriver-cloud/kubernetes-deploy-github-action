#!/bin/bash
set -e

echo $ARTIFACT_KUBERNETES_CLUSTER > kube-config

# output the path to the kubeconfig file so downstream steps can use it.
echo "::set-output name=kube_config::kube-config"

kubectl patch -p '{"spec": {"template": {"spec": {"containers": [{"name": "${{ inputs.application_id }}", "image": "${{ inputs.image }}"}]}}}}'
