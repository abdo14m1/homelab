#!/usr/bin/env bash

helm repo add bitwarden https://charts.bitwarden.com/
helm repo update
helm install bitwarden-operator bitwarden/secrets-manager-operator -n secrets-manager
kubectl create secret generic bw-auth-token -n secrets-manager  --from-literal=token="BW_TOKEN"