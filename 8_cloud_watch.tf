################################################################################
# AWS Fluent bit configuration for Cloud Watch logs
################################################################################
module "fluent-bit" {
  depends_on = [null_resource.kubectl]
  source = "dasmeta/eks/aws//modules/fluent-bit"
  #version = "0.1.4"
  cluster_name                = var.eks_cluster_name
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = var.region
  oidc_provider_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
  eks_oidc_root_ca_thumbprint = replace("eks_oidc_provider_arn", "/.*id//", "")
}
