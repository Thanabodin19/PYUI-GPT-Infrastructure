# PYUI-GPT-Infrastructure
## Setup Tools
install tools
```bash
./0-install_tools.sh
```
### Install Docker
Set up Docker's apt repository.
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
Install the Docker packages.
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Install KinD (Kubernetes in Docker) 🪼
On macOS via Homebrew
```bash
brew install kind
```
On Linux
```bash
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64

sudo mv ./kind /usr/local/bin/kind
```

### Install K9s 🐶
Monitor Cluster
On macOS via Homebrew
```bash
brew install k9s
```
On Linux
```bash
wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb

sudo apt install ./k9s_linux_amd64.deb

rm k9s_linux_amd64.deb
```

## KinD Cluster 
### Create KinD Cluster 🐳 

Run Scrept Create-Cluster.sh
```bash
./kind-cluster/create-cluster.sh
```

### Interacting With Your Cluster 👀
```bash
kubectl cluster-info --context kind-<name cluster>
```

### Loading an Image Into Your Cluster 🚥
```bash
kind load docker-image <my-custom-image:unique-tag>
```
### Delete KinD Cluster 🔪
```bash
./kind-cluster/delete-kind-cluster.sh
```


