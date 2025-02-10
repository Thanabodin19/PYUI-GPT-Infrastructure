#!/bin/bash

export $(xargs <.env)

cd "bootstrap"
helm upgrade -i bootstrap . -f values-${ENV}.yaml -n argocd