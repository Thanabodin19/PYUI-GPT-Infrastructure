# PYUI-GPT-Infrastructure

## 0. Setup Tools
### install tools (only linux)
- Docker 🐳
- KinD (Kubernetes in Docker) 🪼
- k9s 🐶
- kubectl ☸️
- helm ⎈

```bash
./0-install_tools.sh
```

## 1. KinD Cluster 
### Create KinD Cluster 
- Control-plane  
- Worker

```bash
./1-create_cluster.sh
```

## 2. Addons 
### Install Addons
- Argocd
- kube-prometheus-stack
- loki-log
- nginx-ingress
- metric-server
```bash
./2-install_addons.sh 
```
### Get password init
```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d 2>/dev/null
```

## 3. Deploy Database
### Set env database
create `.env` from `.env-template`
```bash
cp .env-template  .env
```
Fill in all required values in `.env`, except `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY`.
### Deploy Database
- mongodb
- minio
```bash
./3-deploy_db.sh
```

## 4. Deploy App
### Set env app
1. Access MinIO and navigate to Access Keys.
2. Create `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY`.
3. Add `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` to the `.env` file.

### Deploy Database
- pyui-app
- pyui-api
- pyui-data-pipeline
```bash
./4-deploy_app.sh
```