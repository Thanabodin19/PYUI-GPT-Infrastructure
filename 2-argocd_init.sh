#!/bin/bash

export $(xargs <.env)

cd "argocd-init"

helm dependency update
helm upgrade -i init . -f values-${ENV}.yaml -n argocd --create-namespace