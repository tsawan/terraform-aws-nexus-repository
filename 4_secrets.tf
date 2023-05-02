################################################################################
# AWS Secrets for Nexus Repository License file
################################################################################
resource "aws_secretsmanager_secret" "license" {
  name                    = var.nexus-license-file-secrets-name
  recovery_window_in_days = var.secrets-recovery-window
}

resource "aws_secretsmanager_secret_version" "license" {
  secret_id     = aws_secretsmanager_secret.license.id
  secret_binary = filebase64(var.nexus-license-file-path)
}

################################################################################
# AWS Secrets for Nexus Repository admin password
################################################################################
locals {
  nxrmpwd = {
    "admin_nxrm_password" : var.nexus-repository-admin-password
  }
}

resource "aws_secretsmanager_secret" "nxrmsecret" {
  name                    = var.nexus-repository-admin-password-secret-name
  recovery_window_in_days = var.secrets-recovery-window
}

resource "aws_secretsmanager_secret_version" "nxrmsecret" {
  secret_id     = aws_secretsmanager_secret.nxrmsecret.id
  secret_string = jsonencode(local.nxrmpwd)
}
################################################################################
# Secrets Manager secrets for Aurora PostgreSQL
################################################################################
locals {
  db = {
    "username" : var.nexus-repository-database-username,
    "password" : var.nexus-repository-database-password
    "host" : module.dbcluster.cluster_endpoint
    "port" : module.dbcluster.cluster_port
  }
}

resource "aws_secretsmanager_secret" "dbsecret" {
  name                    = var.nexus-repository-db-secret-name
  recovery_window_in_days = var.secrets-recovery-window

}

resource "aws_secretsmanager_secret_version" "dbsecret" {
  secret_id     = aws_secretsmanager_secret.dbsecret.id
  secret_string = jsonencode(local.db)
}