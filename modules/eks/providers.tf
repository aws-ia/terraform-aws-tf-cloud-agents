terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.2"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = var.create_eks_cluster ? module.eks.cluster_endpoint : var.cluster_endpoint_url
  cluster_ca_certificate = var.create_eks_cluster ? base64decode(module.eks.cluster_certificate_authority_data) : var.cluster_certificate_authority_data
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = var.create_eks_cluster ? module.eks.cluster_endpoint : var.cluster_endpoint_url
    cluster_ca_certificate = var.create_eks_cluster ? base64decode(module.eks.cluster_certificate_authority_data) : var.cluster_certificate_authority_data
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
