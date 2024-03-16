resource "kubernetes_deployment" "app" {
  metadata {
    name = "python-app"
    
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
      
        python = "app"
      }
    }

    template {
      metadata {
        labels = {
          python = "app"
        }
      }

      spec {
        container {
          image = "yasasrk/linetenapp:test"
          name  = "example"

          // Define ports and other settings as needed
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
