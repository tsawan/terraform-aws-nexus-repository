################################################################################
# Aurora PostgreSQL Database
################################################################################
module "dbcluster" {
  #depends_on = [aws_rds_cluster_parameter_group.default, aws_db_parameter_group.default]
  depends_on = [null_resource.kubectl]
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.7.1"
  name    = var.nexus-repository-database-subnet-group
  engine  = "aurora-postgresql"
  #engine_version = "11.12"
  instance_class = var.nexus-repository-db-writer-instance-class

  #master_username	= local.db_creds.username
  #master_password	= local.db_creds.password
  master_username        = var.nexus-repository-database-username
  master_password        = var.nexus-repository-database-password
  database_name          = var.nexus-repository-database-name
  create_random_password = "false"


  instances = {
    writer = {
      instance_class = var.nexus-repository-db-writer-instance-class
    }
    reader = {
      instance_class = var.nexus-repository-db-reader-instance-class
    }
  }

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  #allowed_security_groups = ["sg-12345678"]
  #allowed_security_groups= module.eks.cluster_security_group.id
  allowed_cidr_blocks = var.public_subnets

  #storage_encrypted   = true
  apply_immediately = var.nexus-repository-database-apply-immediately
  #monitoring_interval = 10

  #db_cluster_parameter_group_name     = join("", aws_rds_cluster_parameter_group.default.*.name)
  #db_parameter_group_name     = join("", aws_db_parameter_group.default.*.name)

  #enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    #Environment = "dev"
    Terraform = "true"
  }
}