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
- Worker2
- Worker3

```bash
./1-create_cluster.sh
```

## 2. Addons 
### Install Addons
- Argocd
- kube-prometheus-stack
- Metallb
```bash
./2-install_addons.sh 
```
### Get password init
```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d 2>/dev/null
```

create .env from .env-template
```bash
cp .env-template  .env
```

