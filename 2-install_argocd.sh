#!/bin/bash

# ตั้งค่า Namespace
ARGOCD_NAMESPACE="argocd"

echo "📌 Creating ArgoCD Namespace..."
kubectl create namespace $ARGOCD_NAMESPACE || echo "Namespace $ARGOCD_NAMESPACE already exists."

echo "🚀 Installing ArgoCD using Helm..."
# เพิ่ม Helm repository สำหรับ ArgoCD
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm repo update

# ติดตั้ง ArgoCD ผ่าน Helm
helm install argocd argo-cd/argo-cd --namespace $ARGOCD_NAMESPACE --create-namespace

# รอให้ ArgoCD Pods Start
echo "⏳ Waiting for ArgoCD pods to be ready..."
sleep 10  # เพิ่มเวลารอให้ Kubernetes เริ่มสร้าง Pods

kubectl wait --for=condition=available --timeout=600s deployment -l app.kubernetes.io/name=argocd -n $ARGOCD_NAMESPACE || {
    echo "❌ ArgoCD deployment failed!"
    exit 1
}

# ตั้งค่า Port Forward เพื่อเข้า UI
echo "🌍 Setting up port-forward for ArgoCD UI (http://localhost:8080)..."
kubectl port-forward svc/argocd-server -n $ARGOCD_NAMESPACE 8080:443 &

# รอให้ Secret ถูกสร้างขึ้น
echo "⏳ Waiting for ArgoCD admin secret..."
sleep 15  # เพิ่มเวลารอให้ Secret ถูกสร้าง

# ดึง Password สำหรับเข้าใช้งาน
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n $ARGOCD_NAMESPACE -o jsonpath="{.data.password}" | base64 -d 2>/dev/null)

if [ -z "$ARGOCD_PASSWORD" ]; then
    echo "❌ Failed to retrieve ArgoCD admin password!"
    exit 1
fi

echo "✅ ArgoCD Admin Password: $ARGOCD_PASSWORD"

echo "🎉 ArgoCD installation completed!"
echo "🔗 Access ArgoCD UI: https://localhost:8080"
echo "👤 Username: admin"
echo "🔑 Password: $ARGOCD_PASSWORD"
