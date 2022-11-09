#!/bin/bash

if [-n $1]
then
  echo "Usage: $0 <version>"
  echo "Example: $0 v2.5.2"
  exit 1
fi

kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f -

kubectl config set-context --current --namespace=argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/${1}/manifests/install.yaml

kubectl apply -f argocd/argocd-server-service.yaml 

echo
echo "--> ArgoCD will be available in a moment on: http://localhost:30000/"