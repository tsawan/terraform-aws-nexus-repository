locals {
  app_name          = "nexus-repository"
  cluster_id        = data.aws_eks_cluster.this.id
  oidc_provider     = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
  kube_namespace    = "kube-system"
  kube_labels = {
    "app.kubernetes.io/name"     = local.app_name
    "app.kubernetes.io/instance" = local.app_name
  }
}