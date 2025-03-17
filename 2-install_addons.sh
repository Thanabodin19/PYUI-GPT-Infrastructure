#!/bin/bash

echo "🚀 Installing ArgoCD using Helm..."
kubectl config use-context kind-pyui-gp
# เพิ่ม Helm repository 
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add metallb https://metallb.github.io/metallb
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# ติดตั้ง Addons ผ่าน Helm
helm upgrade --install argocd argo-cd/argo-cd  --version 7.8.2 --namespace=argocd --create-namespace
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 69.2.3 --namespace=monitoring --create-namespace
helm upgrade --install loki  grafana/loki-stack --namespace=loki-stack --create-namespace
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml
kubectl apply -f https://gitlab.com/settakit.sirisoft/k8s-101-workshop/-/raw/master/workshop/metric-server/metric-server.yaml

echo "🎉 Addons installation completed!"
