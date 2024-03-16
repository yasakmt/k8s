output "cluster_id" {
  value = aws_eks_cluster.example.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.example.certificate_authority[0].data
  description = "The base64 encoded certificate data required to communicate with the cluster."
}

