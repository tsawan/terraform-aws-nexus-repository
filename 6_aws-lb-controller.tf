################################################################################
# AWS Load Balancer Controller
################################################################################
module "aws_alb_irsa_role" {
  depends_on = [null_resource.kubectl]
  source     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "nxrm-alb-controller-role-${var.region}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "helm_release" "aws-load-balancer-controller" {
  name = var.aws-load-balancer-controller
  depends_on = [null_resource.kubectl]
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.aws_alb_irsa_role.iam_role_arn
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "image.repository"
    value = format("602401143452.dkr.ecr.%s.amazonaws.com/amazon/aws-load-balancer-controller", var.region)
  }

  set {
    name  = "image.tag"
    value = "v2.5.0"
  }

}

resource "kubernetes_secret" "aws-load-balancer-controller-sa-secret" {
  depends_on = [null_resource.kubectl]
  metadata {
    name = "aws-load-balancer-controller-sa-secret"
  }
}

resource "kubernetes_secret" "aws_alb_sa_token" {
  depends_on = [null_resource.kubectl]
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "aws-load-balancer-controller"
    }
    name      = "aws-load-balancer-controller-sa-secret"
    namespace = "kube-system"
  }

  type = "kubernetes.io/service-account-token"
}
