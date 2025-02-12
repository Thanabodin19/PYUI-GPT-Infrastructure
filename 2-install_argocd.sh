#!/bin/bash

# ตั้งค่า Namespace
ARGOCD_NAMESPACE="argocd"

echo "📌 Creating ArgoCD Namespace..."
kubectl create namespace $ARGOCD_NAMESPACE

echo "🚀 Installing ArgoCD..."
kubectl apply -n $ARGOCD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# รอให้ ArgoCD Pods Start
echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=600s deployment -l app.kubernetes.io/name=argocd -n $ARGOCD_NAMESPACE

# ตั้งค่า Port Forward เพื่อเข้า UI
echo "🌍 Setting up port-forward for ArgoCD UI (http://localhost:8080)..."
kubectl port-forward svc/argocd-server -n $ARGOCD_NAMESPACE 8080:443 &

# ดึง Password สำหรับเข้าใช้งาน
echo "🔑 Getting ArgoCD initial admin password..."
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n $ARGOCD_NAMESPACE -o jsonpath="{.data.password}" | base64 -d)
echo "✅ ArgoCD Admin Password: $ARGOCD_PASSWORD"

echo "🎉 ArgoCD installation completed!"
echo "🔗 Access ArgoCD UI: https://localhost:8080"
echo "👤 Username: admin"
echo "🔑 Password: $ARGOCD_PASSWORD"
