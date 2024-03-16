resource "kubernetes_service" "app" {
  metadata {
    name = "python-app"
    
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "external"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type"= "ip"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facin"

    }
    
  }

  spec {
    selector = {
      python = "app"
    }

    port {
      port        = 80
      target_port = 8080
      
    }

    type = "LoadBalancer"
  }
}
