# Output for Kubernetes Deployment
output "deployment_name" {
  description = "The name of the deployment."
  value       = kubernetes_deployment.app.metadata[0].name
}

output "deployment_namespace" {
  description = "The namespace of the deployment."
  value       = kubernetes_deployment.app.metadata[0].namespace
}

/*
output "deployment_ready_replicas" {
  description = "The number of ready replicas in the deployment."
  value       = kubernetes_deployment.app.status[0].ready_replicas
}
*/

# Optional: Output for Kubernetes Service (if you have an external service like LoadBalancer)
output "service_external_ip" {
  description = "The external IP address of the service, if available."
  value       = kubernetes_service.app.status[0].load_balancer[0].ingress[0].ip
}

output "service_external_hostname" {
  description = "The external hostname of the service, if available."
  value       = kubernetes_service.app.status[0].load_balancer[0].ingress[0].hostname
}
