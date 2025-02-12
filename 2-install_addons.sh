#!/bin/bash

# ตั้งค่า Namespace
ARGOCD_NAMESPACE="argocd"
MONITORING_NAMESPACE="monitoring"
METALLB_NAMESPACE="metallb"
NGINX_NAMESPACE="ingress-nginx"

echo "🚀 Installing ArgoCD using Helm..."
# เพิ่ม Helm repository 
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add metallb https://metallb.github.io/metallb
helm repo update

# ติดตั้ง Addons ผ่าน Helm
helm upgrade --install argocd argo-cd/argo-cd  --version 7.8.2 --namespace $ARGOCD_NAMESPACE --create-namespace
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 69.2.3 --namespace $MONITORING_NAMESPACE --create-namespace
helm upgrade --install metallb metallb/metallb --version 0.14.9 --version 69.2.3 --namespace $METALLB_NAMESPACE --create-namespace

echo "🎉 Addons installation completed!"
