#!/bin/bash

set -e  # หยุดการทำงานทันทีหากเกิดข้อผิดพลาด

echo "🚀 Starting installation of Docker, KinD, and K9s..."

# Update and install dependencies
echo "🔄 Updating package lists and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl wget gnupg lsb-release

# Install Docker
echo "🐳 Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
echo "🔧 Enabling and starting Docker service..."
sudo systemctl enable --now docker
newgrp docker
sudo usermod -aG docker $USER

# Install KinD
echo "🪼 Installing KinD..."
KIND_VERSION="v0.26.0"
KIND_BIN="/usr/local/bin/kind"
curl -Lo ./kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64
sudo mv ./kind $KIND_BIN
sudo chmod +x $KIND_BIN

# Install K9s
echo "🐶 Installing K9s..."
K9S_VERSION="v0.32.5"
wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_linux_amd64.deb
sudo apt install -y ./k9s_linux_amd64.deb
rm k9s_linux_amd64.deb

# Done!
echo "✅ Installation complete! Please restart your terminal for Docker group changes to take effect."
