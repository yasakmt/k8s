output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets # Ensure this matches the actual output
}

/*
output "private_subnets_ids" {
  value = module.vpc.aws_subnet_ids.private
}

output "public_subnets_ids" {
  value = module.vpc.aws_subnet_ids.public
  
}
*/