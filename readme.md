# KinD Cluster 

## Install KinD (Kubernetes in Docker) 🪼
On macOS via Homebrew
```bash
brew install kind
```

## Install K9s 🐶
Moniter
On macOS via Homebrew
```bash
brew install k9s
```

## Create KinD Cluster 🐳 

Run Scrept Create-Cluster.sh
```bash
./kind-cluster/create-cluster.sh
```

## Interacting With Your Cluster 👀
```bash
kubectl cluster-info --context kind-<name cluster>
```

## Loading an Image Into Your Cluster 🚥
```bash
kind load docker-image <my-custom-image:unique-tag>
```
## Delete KinD Cluster 🔪
```bash
./kind-cluster/delete-kind-cluster.sh
```


