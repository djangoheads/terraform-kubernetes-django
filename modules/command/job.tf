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
          volume_mount {
            name       = "${var.name}-settings"
            mount_path = "/home/app/config/override.yaml"
            sub_path = "override.yaml"
            read_only  = true
          }
          volume_mount {
            name       = "${var.name}-secrets"
            mount_path = "/home/app/config/.secrets.yaml"
            sub_path = ".secrets.yaml"
            read_only  = true
          }
        }
        restart_policy = "Never"

        # Volumes 
        volume {
          name = "${var.name}-settings"
          config_map {
            name = "${var.name}-dynaconf"
          }
        }
        volume {
          name = "${var.name}-secrets"
          secret {
            secret_name = "${var.name}-dynaconf"
          }
        }

      }
    }
  }
  wait_for_completion = var.wait
}
