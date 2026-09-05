terraform {
  backend "s3" {
    bucket       = "dev-secops-bucket-1234"
    region       = "us-east-1"
    key          = "End-to-End-Kubernetes-DevSecOps-Tetris-Project/Jenkins-Server-TF/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
  required_version = ">=1.13.3"
  required_providers {
    aws = {
      version = ">= 6.23.0"
      source  = "hashicorp/aws"
    }
    tls = {
      version = ">= 4.0.0"
      source  = "hashicorp/tls"
    }
    local = {
      version = ">= 2.5.0"
      source  = "hashicorp/local"
    }
  }
}