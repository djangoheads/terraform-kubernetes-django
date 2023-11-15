resource "kubernetes_job" "command" {
  count = var.role == "command" ? 1 : 0
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
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }

          # Mounts
        }
        restart_policy = "Never"

        # Volumes 

      }
    }
  }
  wait_for_completion = var.wait
}
