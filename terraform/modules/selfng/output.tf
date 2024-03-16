output "autoscaling_group_arn" {
  value = aws_autoscaling_group.eks_nodes.arn
}


output "eks_node_role_arn" {
  value = aws_iam_role.eks_nodes.arn
}
