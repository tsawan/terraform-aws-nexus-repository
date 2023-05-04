variable "region" {
  type        = string
  description = "AWS Region where you want the services to be deployed"
  default     = "us-west-1"
}

variable "azs_list" {
  type        = list(string)
  description = "List of Availability Zones"
  default     = ["us-west-1b", "us-west-1c"]
}

variable "profile" {
  type        = string
  description = "Enter the name of your AWS Profile"
  default = "devnxrm"
}

variable "kubernetes_config_file_path" {
  type        = string
  description = "Kube config location path"
  default     = "~/.kube/config"
}

variable "cidr" {
  type        = string
  description = "Cidr block for the VPC"
  default     = "10.0.0.0/24"
}

variable "secondary_cidrs" {
  type        = list(string)
  description = "Secondary CIDR blocks of the VPC"
  default     = ["10.1.0.0/24"]
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "nexus-repository-vpc"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnets of the VPC"
  default     = ["10.0.0.0/24", "10.1.0.0/24"]
}

variable "default_route_table" {
  type        = string
  description = "Name of the Route Table"
  default     = "nexus-repository-routes"
}

variable "eks_cluster_version" {
  type        = string
  description = "EKS Cluster Version"
  default     = "1.26"
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "nexus-repository-cluster"
}

variable "eks_cluster_node_grp_name" {
  type        = string
  description = "EKS Cluster Node Group Name"
  default     = "nxrm-cluster-node-grp"
}

variable "eks_node_instance_types" {
  type        = list(string)
  description = "Instance Types for the nodes"
  default     = ["t3.2xlarge"]
}

variable "eks_node_instance_capacity_type" {
  type        = string
  description = "Instance Capacity Types for the nodes"
  default     = "ON_DEMAND"
}

variable "eks_nodes_count" {
  type = map(any)
  default = {
    "min_size"     = "2"
    "max_size"     = "2"
    "desired_size" = "2"
  }
}

variable "nexus-license-file-path" {
  type        = string
  description = "License file path"
}

variable "nexus-license-file-secrets-name" {
  type        = string
  description = "Name of the AWS Secret for License file Name"
  default     = "nexus-repository-license"
}

variable "nexus-repository-admin-password" {
  type        = string
  description = "Admin password for Nexus Repsitory"
  default     = "sonatype"
}

variable "nexus-repository-admin-password-secret-name" {
  type        = string
  description = "AWS Secret name for Nexus Repsitory Admin password"
  default     = "nexus-repository-password"
}

variable "nexus-repository-database-username" {
  type        = string
  description = "Database Username"
  default     = "nxrm"
}

variable "nexus-repository-database-password" {
  type        = string
  description = "Default Database Password"
  default     = "s0natype"
}

variable "nexus-repository-db-secret-name" {
  type        = string
  description = "AWS Secret name for Nexus Repsitory Database secrets"
  default     = "nexus-repository-db"
}

variable "secrets-recovery-window" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  default     = 0
}

variable "nexus-repository-db-writer-instance-class" {
  type        = string
  description = "Instance class for Aurora PostgreSQL Database"
  default     = "db.r6g.2xlarge"
}

variable "nexus-repository-db-reader-instance-class" {
  type        = string
  description = "Instance class for Aurora PostgreSQL Database"
  default     = "db.r6g.2xlarge"
}

variable "nexus-repository-database-subnet-group" {
  type        = string
  description = "Name of the DB Subnet Group"
  default     = "nexus-component-db"
}

variable "nexus-repository-database-name" {
  type        = string
  description = "Name of the Nexus Repository database"
  default     = "nexus"
}

variable "nexus-repository-database-apply-immediately" {
  type        = string
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "nexus-repository-db-port" {
  type        = string
  description = "Aurora PostgreSQL Database port"
  default     = "5432"
}

variable "aws-load-balancer-controller" {
  type        = string
  description = "Name of the AWS Load Balancer Controller"
  default     = "aws-load-balancer-controller"
}

variable "nexus-repository-instances-count" {
  type        = string
  description = "Number of Nexus Repository instances"
  default     = "2"
}

variable "nexus-repository-image" {
  type        = string
  description = "Nexus Repository Image"
  default     = "sonatype/nexus3"
}

variable "nexus-repository-version" {
  type        = string
  description = "Nexus Repository Image version"
  default     = "3.52.0"
}

variable "nexus-repository-sa-name" {
  type        = string
  description = "Nexus Repository Service Account Name"
  default     = "nexus-repository-sa"
}

variable "nexus-repository-lb-scheme" {
  type        = string
  description = "Scheme for Nexus Repository Ingress"
  default     = "internet-facing"
}

variable "nexus-repository-kubernetes-namespace" {
  type        = string
  description = "Kubernetes Namespace for Nexus Repository cluster"
  default     = "nexusrepo"
}

variable "enable-cloud-watch" {
  type        = string
  description = "Enable Fluentbit configuration for Cloudwatch"
  default     = true
}

variable "namespace-cloud-watch" {
  type        = string
  description = "Namespace for Fluentbit Cloudwatch configuration"
  default     = "amazon-cloudwatch"
}

variable "helmcharts-release-name" {
  type        = string
  description = "Name of Helm Chart Release"
  default     = "nxrm"
}

variable "statefulset-container-resources" {
  type = map(any)
  default = {
    "requests-cpu"= "4"
    "requests-memory"= "8Gi"
    "limits-cpu"= "4"
    "limits-memory"= "8Gi"
  }
}

variable "nexus-repository-port" {
  type        = string
  description = "Nexus Repository Port"
  default     = "8081"
}