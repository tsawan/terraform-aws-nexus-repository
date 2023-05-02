
output "nexus_repository_subnets" {
  value = module.vpc.public_subnets
}

output "nexus_repository_vpc_id" {
  value = module.vpc.vpc_id
}
