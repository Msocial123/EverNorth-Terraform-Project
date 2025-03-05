# https://registry.terraform.io/providers/hashicorp/aws/latest

provider "aws" {
  region = var.aws_region
}

#https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
# To create service account for ingress controller
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks-cluster-name]
    command     = "aws"
  }
}

# To create Ingress controller
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks-cluster-name]
      command     = "aws"
    }
  }
}

# https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs
# To create cluster autoscaler
provider "kubectl" {
  config_path            = var.kubeconfig
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws-iam-authenticator"
    args        = ["eks", "get-token", "--cluster-name", var.eks-cluster-name]
  }
}

terraform {
  required_version = ">= 0.13"

  # backend "s3" {
  #   bucket         = "terraformstateaks"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "state-locking"
  # }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.1"
    }
  }
}