################################################################################
# EKS Cluster Role for Secrets and S3
################################################################################
resource "kubernetes_namespace_v1" "app" {
  depends_on = [null_resource.kubectl]
  metadata {
    name = var.nexus-repository-kubernetes-namespace
  }
}

data "aws_iam_policy_document" "assume_role_iamserviceaccount" {
  depends_on = [null_resource.kubectl]
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values = [
        format(
          "system:serviceaccount:%s:%s",
          kubernetes_namespace_v1.app.metadata[0].name,
          var.nexus-repository-sa-name
        )
      ]
    }

    principals {
      identifiers = [local.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "secrets_storage_csi" {
  depends_on = [null_resource.kubectl]  
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = [
      aws_secretsmanager_secret.license.arn,
      aws_secretsmanager_secret.nxrmsecret.arn,
      aws_secretsmanager_secret.dbsecret.arn
    ]
  }
}

resource "aws_iam_policy" "secret_storage_class" {
  policy = data.aws_iam_policy_document.secrets_storage_csi.json
  name   = "app-${local.app_name}-access-to-sensitive"
}

# S3 policy
data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "s3-policy" {
  name   = "nxrm-s3-policy"
  policy = data.aws_iam_policy_document.policy.json
}


# AWS IAM role with permissions for Secrets and S3
resource "aws_iam_role" "eks_iamserviceaccount_app" {
  depends_on = [null_resource.kubectl]
  name               = "eks-${local.cluster_id}-app-${var.region}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_iamserviceaccount.json
  managed_policy_arns = [
    aws_iam_policy.secret_storage_class.arn, aws_iam_policy.s3-policy.arn
  ]
}
