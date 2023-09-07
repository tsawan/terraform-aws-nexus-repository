module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  version               = "5.1.1"
  name                  = var.vpc_name
  cidr                  = var.cidr
  secondary_cidr_blocks = var.secondary_cidrs

  azs = var.azs_list
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  #public_subnets  = ["10.0.0.0/24", "10.1.0.0/24"]
  public_subnets = var.public_subnets

  enable_nat_gateway = true
  #enable_vpn_gateway = true

  default_route_table_name = var.default_route_table

  enable_dns_support      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    #Environment = "dev"
  }
}

module "endpoints" {
  source     = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  endpoints = {
    s3 = {
      service_type = "Gateway"
      service      = "s3"
      subnet_ids   = module.vpc.public_subnets
    }
  }
}


