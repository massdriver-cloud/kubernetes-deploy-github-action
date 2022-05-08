#!/bin/bash
set -e

CERTIFICATE_AUTHORITY_DATA=$(jq '.authentication.cluster."certificate-authority-data"' data.json | sed s/\"//g)
CLUSTER_IP=$(jq '.authentication.cluster.server' data.json | sed s/\"//g)
TOKEN=$(jq '.authentication.user.token' data.json | sed s/\"//g)

sed "s/<certificate-authority-data>/${CERTIFICATE_AUTHORITY_DATA}/" kube-config-template > kube-config.tmp-0
sed "s/<cluster-ip>/${CLUSTER_IP}/" kube-config.tmp-0 > kube-config.tmp-1
sed "s/<user-token>/${TOKEN}/" kube-config.tmp-1 > kube-config

rm kube-config.tmp-0 kube-config.tmp-1
# set the env var for our custom file
export KUBECONFIG=kube-config


# api_url="https://pokeapi.co/api/v2/pokemon/${INPUT_POKEMON_ID}"
# echo $api_url

# pokemon_name=$(curl "${api_url}" | jq ".name")
# echo $pokemon_name

# echo "::set-output name=pokemon_name::$pokemon_name"





