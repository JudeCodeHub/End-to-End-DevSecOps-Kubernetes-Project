# 🚀 End-to-End DevSecOps Kubernetes Project 🌐

![DevSecOps](https://img.shields.io/badge/DevSecOps-Mastery-brightgreen)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-blueviolet)
![Jenkins](https://img.shields.io/badge/Jenkins-Automation-orange)
![ArgoCD](https://img.shields.io/badge/ArgoCD-Continuous%20Delivery-blue)
![Docker](https://img.shields.io/badge/Docker-Containerization-blue)
![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-9cf)

## 📖 What Is This Project?

This project is a hands-on DevSecOps pipeline built around a simple Tetris game. The game itself isn't the point — it's the vehicle for demonstrating a complete, secure, automated path from a code commit to a running application on Kubernetes.

It covers infrastructure provisioning, CI/CD automation, security scanning at multiple stages, containerization, and GitOps-style deployment — all wired together so you can see how these tools work as one system rather than in isolation.

## 🏗️ Architecture

![Infrastructure Diagram](assets/Infra.gif)

In simple terms, here's what happens end to end:

1. **Infrastructure is provisioned with Terraform.** Two sets of Terraform code spin up AWS resources: one for the Jenkins EC2 server, and one for the EKS (Kubernetes) cluster.
2. **A developer pushes code to GitHub.** This triggers a Jenkins pipeline.
3. **Jenkins builds and secures the code.** The pipeline runs SonarQube for code quality, OWASP Dependency-Check for vulnerable dependencies, and Trivy to scan for vulnerabilities in the filesystem and container image — catching issues before they ship.
4. **The app is containerized.** Jenkins builds a Docker image of the Tetris app and pushes it to a container registry.
5. **The Kubernetes manifests are updated.** Jenkins commits the new image tag to the deployment manifest in Git (GitOps).
6. **ArgoCD deploys to EKS.** ArgoCD watches the Git repo and automatically syncs the updated manifest to the EKS cluster, rolling out the new version.
7. **The app is exposed to the world.** A Kubernetes Service/Ingress exposes Tetris so it's reachable from a browser.

The result: every code change flows through security checks and automated deployment with no manual steps in between.

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| Infrastructure as Code | Terraform |
| Cloud Provider | AWS (EC2, EKS, S3, VPC) |
| CI/CD | Jenkins |
| GitOps / Continuous Delivery | ArgoCD |
| Container Orchestration | Kubernetes |
| Containerization | Docker |
| Code Quality | SonarQube |
| Dependency Scanning | OWASP Dependency-Check |
| Vulnerability Scanning | Trivy |
| Application | React (Tetris game) |

## 📂 Directories

1. **EKS-TF:** Terraform scripts for deploying the EKS cluster on AWS.
2. **Jenkins-Server-TF:** Terraform scripts for provisioning the Jenkins server on AWS EC2.
3. **Jenkins-Pipeline-Code:** Jenkins pipeline code for automated CI/CD.
4. **Manifest-file:** Kubernetes manifest files for the Tetris application deployment.
5. **Tetris-V1:** Initial version of the Tetris game application.
6. **Tetris-V2:** Enhanced version of the Tetris game application.

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<YOUR_GITHUB_USERNAME>/End-to-End-Kubernetes-DevSecOps-Tetris-Project.git
   ```
2. **Explore the directories:**
   Navigate into each directory to find detailed scripts, pipelines, and configurations.

## 🙌 Acknowledgments

Special thanks to the open-source community and the contributors who make learning and collaboration an incredible journey.
