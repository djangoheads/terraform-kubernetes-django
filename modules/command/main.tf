resource "kubernetes_job" "command" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }
  spec {
    ttl_seconds_after_finished = 100
    backoff_limit = 5
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
          volume_mount {
            name       = "${var.name}-dynaconf-settings"
            mount_path = var.settings_mount_path
            read_only  = true
          }
          volume_mount {
            name       = "${var.name}-dynaconf-secrets"
            mount_path = var.secrets_mount_path 
            read_only  = true
          }
        }
        restart_policy = "Never"

        # Volumes 
        volume {
          name = "${var.name}-dynaconf-settings" 
          config_map {
            name = "${var.name}-dynaconf"
          }
        }
        volume {
          name = "${var.name}-dynaconf-secrets" 
          secret {
            secret_name = "${var.name}-dynaconf"
          }
        }

      }
    }
  }
  wait_for_completion = var.wait
}
