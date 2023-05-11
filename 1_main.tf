terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "4.63.0"
    }
   utils = {
      source = "cloudposse/utils"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    } 
    kubernetes ={
      source  = "hashicorp/kubernetes"
      #version = ">= 2.19.0"
     }
  }
  
}

provider "aws" {
  region  = var.region
  #profile = var.profile
  #version = ">= 3.72, < 4.46.0"
}

provider "helm" {
  kubernetes {
    config_path    = var.kubernetes_config_file_path
    config_context = module.eks.cluster_arn
  }
}

provider "kubernetes" {
  config_path    = var.kubernetes_config_file_path
  config_context = module.eks.cluster_arn
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_eks_cluster" "this" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}
