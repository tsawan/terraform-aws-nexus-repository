module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.1"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               =module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups  = {
    nexus-repository = {
      name         = var.eks_cluster_node_grp_name
      min_size     = var.eks_nodes_count["min_size"]
      max_size     = var.eks_nodes_count["max_size"]
      desired_size = var.eks_nodes_count["desired_size"]
    instance_types = var.eks_node_instance_types
    capacity_type  = var.eks_node_instance_capacity_type

    # Needed by the aws-ebs-csi-driver and Cloudwatch
    iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy    = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        CloudWatchFullAccess        = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    }

    tags = {
        #Environment = "dev"
        Terraform = "true"
    }
    }
  }
}

data "utils_aws_eks_update_kubeconfig" "update_kube_config_file" {
  depends_on = [module.eks]
  #profile      = var.profile
  cluster_name = var.eks_cluster_name
  region= var.region
  kubeconfig   = var.kubernetes_config_file_path
}

resource "null_resource" "kubectl" {
    depends_on = [module.eks]
  #  provisioner "local-exec" {
  #      command = "aws eks --region ${var.region} update-kubeconfig --name ${var.eks_cluster_name} --profile ${var.profile}"
  #  }
}

################################################################################
# EKS Cluster Add-ons
################################################################################
resource "aws_eks_addon" "core_dns" {
  depends_on   = [null_resource.kubectl]
  cluster_name = var.eks_cluster_name
  addon_name   = "coredns"
  #addon_version     = "v1.8.3-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  depends_on        = [null_resource.kubectl]
  cluster_name      = var.eks_cluster_name
  addon_name        = "aws-ebs-csi-driver"
  resolve_conflicts = "OVERWRITE"
}

/*
provider "kubernetes" {
  config_path    = var.kubernetes_config_file_path
  config_context = module.eks.cluster_arn
}

variable "name" {
  default =""
}

data "aws_eks_cluster" "cluster" {
   name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
   name = module.eks.cluster_name
}


provider "kubernetes" {
  #host                  = data.aws_eks_cluster.cluster.endpoint
  host                   = module.eks.cluster_endpoint	
  cluster_ca_certificate = base64decode(cluster_certificate_authority_data)
  #token                 = data.aws_eks_cluster_auth.cluster.token
  #load_config_file      = false
  #version               = "~> 2.12"
}
*/




 
