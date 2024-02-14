resource "kubernetes_job" "command" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }
  spec {
    ttl_seconds_after_finished = 100
    backoff_limit              = 5
    template {
      metadata {
        labels = {
          app = var.name
          config_revision = var.config_revision
          secret_revision = var.secret_revision
        }
      }
      spec {
        container {
          name              = "main"
          image             = var.image
          command           = var.command
          args              = var.args
          image_pull_policy = var.image_pull_policy
          working_dir = var.working_dir
          resources {
            limits   = length(var.limits) > 0 ? var.limits : null
            requests = length(var.requests) > 0 ? var.requests : null
          }
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
            sub_path   = var.configmap_path
            read_only  = true
          }
          volume_mount {
            name       = "${var.name}-dynaconf-settings"
            mount_path = var.secrets_mount_path
            sub_path   = var.secret_path
            read_only  = true
          }
        }
        restart_policy = "Never"

        # Volumes
        volume {
          name = "${var.name}-dynaconf-settings"
          projected {
            sources {
              config_map {
                optional = true
                name = var.configmap_name
                items {
                  key  = var.configmap_key
                  path = var.configmap_path
                }
              }
              secret {
                optional = true
                name = var.secret_name
                items {
                  key  = var.secret_key
                  path = var.secret_path
                }
              }
            }
          }
        }


      }
    }
  }
  wait_for_completion = var.wait
}
