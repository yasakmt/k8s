
output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Endpoint for EKS cluster"
}

output "cluster_id" {
  description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
  value       = module.eks.cluster_id
}

/*
output "eks_node_role_arn" {
  value = module.self-manged-nodegroup.eks_node_role_arn
}
*/
