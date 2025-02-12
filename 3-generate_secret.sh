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

# สร้างไฟล์ Secret YAML ที่ secrets/init-secrets.yaml
cat <<EOF > secrets/init-secrets.yaml
apiVersion: v1
data:
  MONGO_INITDB_ROOT_USERNAME: $(encode_base64 "$MONGO_INITDB_ROOT_USERNAME")
  MONGO_INITDB_ROOT_PASSWORD: $(encode_base64 "$MONGO_INITDB_ROOT_PASSWORD")
kind: Secret
metadata:
  name: mongodb-secrets
---
apiVersion: v1
data:
  MONGODB_URI: $(encode_base64 "$MONGODB_URI")
  NEXTAUTH_SECRET: $(encode_base64 "$NEXTAUTH_SECRET")
  NEXTAUTH_URL: $(encode_base64 "$NEXTAUTH_URL")
kind: Secret
metadata:
  name: pyui-secrets
EOF

echo "✅ secrets/init-secrets.yaml ถูกสร้างเรียบร้อยแล้ว!"

# Apply Secret to Kubernetes cluster 
kubectl apply -f secrets/init-secrets.yaml

echo "✅ Secrets ถูกสร้างบน Kubernetes cluster แล้ว!"