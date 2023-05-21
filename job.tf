resource "kubernetes_job" "command" {
  count = var.role == "command" ? 1 : 0
  metadata {
    namespace = var.namespace
    name      = var.name
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "main"
          image   = "${var.image.name}:${var.image.tag}:"
          command = var.command

          # Mounts
          volume_mount {
            name       = var.name
            mount_path = "/etc/app/config"
            read_only  = true
          }

          volume_mount {
            name       = var.name
            mount_path = "/etc/app/secrets"
            read_only  = true
          }
        }
        restart_policy = "Never"

        # Volumes 
        volume {
          name = var.name
          config_map {
            name = var.name
          }
        }

        volume {
          name = var.name
          secret {
            secret_name = var.name
          }
        }
      }
    }
  }
  wait_for_completion = var.wait
}
