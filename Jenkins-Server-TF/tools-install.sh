#!/bin/bash
set -euo pipefail
# Ubuntu 22.04 / 24.04

sudo apt update
sudo mkdir -p /etc/apt/keyrings

# ---- Java 21 ----
sudo apt install -y fontconfig openjdk-21-jre unzip wget gnupg curl \
  ca-certificates software-properties-common apt-transport-https

# ---- Jenkins ----
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins

# ---- Docker (upstream, not docker.io) ----
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker jenkins
sudo usermod -aG docker "$USER"
sudo systemctl restart jenkins   # so Jenkins picks up the docker group

# ---- SonarQube ----
echo "vm.max_map_count=524288" | sudo tee /etc/sysctl.d/99-sonarqube.conf
sudo sysctl --system
sudo docker volume create sonar_data
sudo docker volume create sonar_ext
sudo docker run -d --name sonarqube --restart unless-stopped -p 9000:9000 \
  -v sonar_data:/opt/sonarqube/data \
  -v sonar_ext:/opt/sonarqube/extensions \
  sonarqube:community

# ---- Terraform ----
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor \
  | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# ---- kubectl (set to match your EKS cluster) ----
K8S_VERSION="$(curl -Ls https://dl.k8s.io/release/stable.txt)"
curl -LO "https://dl.k8s.io/release/$${K8S_VERSION}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$${K8S_VERSION}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl kubectl.sha256
kubectl version --client

# ---- AWS CLI v2 ----
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q -o awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip

# ---- Trivy (new repo) ----
wget -qO - https://get.trivy.dev/deb/public.key | gpg --dearmor \
  | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://get.trivy.dev/deb generic main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update && sudo apt install -y trivy
trivy --version

echo "Jenkins initial password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword