resource "kubernetes_job" "command" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }
  spec {
    ttl_seconds_after_finished = 100
    backoff_limit = 1
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        container {
          name    = "main"
          image   = var.image
          command = var.command
          args    = var.args

          # Mounts
        }
        restart_policy = "Never"

        # Volumes 

      }
    }
  }
  wait_for_completion = var.wait
}
