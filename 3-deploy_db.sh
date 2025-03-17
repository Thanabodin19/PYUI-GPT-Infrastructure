#!/bin/bash

# โหลดค่าจาก .env
set -a
source .env
set +a

# ฟังก์ชันเข้ารหัส Base64 (ให้รองรับทั้ง macOS และ Linux)
encode_base64() {
  echo -n "$1" | base64 | tr -d '\n'
}

kubectl create namespace minio

# ตรวจสอบว่ามีโฟลเดอร์ secrets หรือไม่ ถ้าไม่มีให้สร้าง
mkdir -p secrets

# สร้างไฟล์ Secret YAML ที่ secrets/db-secrets.yaml
cat <<EOF > secrets/db-secrets.yaml
apiVersion: v1
data:
  MONGO_INITDB_ROOT_USERNAME: $(encode_base64 "$MONGO_INITDB_ROOT_USERNAME")
  MONGO_INITDB_ROOT_PASSWORD: $(encode_base64 "$MONGO_INITDB_ROOT_PASSWORD")
kind: Secret
metadata:
  name: mongodb-secrets
---
apiVersion: v1
kind: Secret
metadata:
  name: minio-secrets
  namespace: minio
type: Opaque
data:
  MINIO_ROOT_USER: $(encode_base64 "$MINIO_ROOT_USER")
  MINIO_ROOT_PASSWORD: $(encode_base64 "$MINIO_ROOT_PASSWORD")
EOF

echo "✅ db-secrets.yaml ถูกสร้างเรียบร้อยแล้ว!"

# Apply Secret to Kubernetes cluster 
kubectl config use-context kind-pyui-gpt
kubectl apply -f secrets/db-secrets.yaml

echo "✅ Secrets ถูกสร้างบน Kubernetes cluster แล้ว!"

# Deploy MongoDB and MinIO 
kubectl apply -f pyui/mongodb.yaml
kubectl apply -f pyui/minio.yaml
