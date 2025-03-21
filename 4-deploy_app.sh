#!/bin/bash

# โหลดค่าจาก .env
set -a
source .env
set +a

# ฟังก์ชันเข้ารหัส Base64 (ให้รองรับทั้ง macOS และ Linux)
encode_base64() {
  echo -n "$1" | base64 | tr -d '\n'
}

# ตรวจสอบว่ามีโฟลเดอร์ secrets หรือไม่ ถ้าไม่มีให้สร้าง
mkdir -p secrets

# สร้างไฟล์ Secret YAML ที่ secrets/app-secrets.yaml
cat <<EOF > secrets/app-secrets.yaml
apiVersion: v1
data:
  MONGODB_URI: $(encode_base64 "$MONGODB_URI")
  NEXTAUTH_SECRET: $(encode_base64 "$NEXTAUTH_SECRET")
  NEXTAUTH_URL: $(encode_base64 "$NEXTAUTH_URL")
  NEXT_PUBLIC_FASTAPI_ENDPOINT: $(encode_base64 "$NEXT_PUBLIC_FASTAPI_ENDPOINT")
  NEXT_PUBLIC_AIRFLOW_ENDPOINT: $(encode_base64 "$NEXT_PUBLIC_AIRFLOW_ENDPOINT")
  NEXT_PUBLIC_AIRFLOW_USERNAME: $(encode_base64 "$NEXT_PUBLIC_AIRFLOW_USERNAME")
  NEXT_PUBLIC_AIRFLOW_PASSWORD: $(encode_base64 "$NEXT_PUBLIC_AIRFLOW_PASSWORD")
kind: Secret
metadata:
  name: pyui-secrets
---
apiVersion: v1
kind: Secret
metadata:
  name: pyui-api-secrets
type: Opaque
data:
  MINIO_ACCESS_KEY: $(encode_base64 "$MINIO_ACCESS_KEY")
  MINIO_SECRET_KEY: $(encode_base64 "$MINIO_SECRET_KEY")
  MINIO_ENDPOINT: $(encode_base64 "$MINIO_ENDPOINT")
  MINIO_PORT: $(encode_base64 "$MINIO_PORT")
  OPENAI_API_KEY: $(encode_base64 "$OPENAI_API_KEY")
  ANTHROPIC_API_KEY: $(encode_base64 "$ANTHROPIC_API_KEY")
  TYPHOON_API_KEY: $(encode_base64 "$TYPHOON_API_KEY")
  SECRET_KEY: $(encode_base64 "$SECRET_KEY")
  ALGORITHM: $(encode_base64 "$ALGORITHM")
  HF_MODEL_NAME: $(encode_base64 "$HF_MODEL_NAME")
  MONGODB_API_ENDPOINT: $(encode_base64 "$MONGODB_API_ENDPOINT")
EOF

echo "✅ secrets/app-secrets.yaml ถูกสร้างเรียบร้อยแล้ว!"

# Apply Secret to Kubernetes cluster 
kubectl config use-context kind-pyui-gpt
kubectl apply -f secrets/app-secrets.yaml

echo "✅ Secrets ถูกสร้างบน Kubernetes cluster แล้ว!"

# Deploy App and Api
kubectl apply -f pyui/pyui-app.yaml
kubectl apply -f pyui/pyui-api.yaml

# pvc airflow
kubectl create namespace airflow
kubectl apply -f pyui/airflow-pvc.yaml