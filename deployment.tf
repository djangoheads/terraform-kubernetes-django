resource "kubernetes_deployment" "server" {
  count = contains(["server", "worker"], var.role) ? 1 : 0
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }
  spec {
    replicas = var.replicas.min
    selector {
      match_labels = {
        app = var.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        container {
          image = var.image
          name  = "main"
          command = var.command
          args = var.args
          dynamic "env" {
              for_each = var.env_vars
              content {
                name  = env.key
                value = env.value
              }       
            }


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

          # Server part
          dynamic "port" {
            for_each = var.role == "server" ? [1] : []
            content {
              container_port = var.port
            }
          }
        }

        # Volumes 
        volume {
          name = var.name
          config_map {
            name = var.name
          }
        }
      }
    }
  }

  wait_for_rollout = var.wait

  depends_on = [
    kubernetes_config_map.main,
    kubernetes_secret.main
  ]
}

resource "kubernetes_horizontal_pod_autoscaler" "autoscaler" {
  count = contains(["server", "worker"], var.role) && var.replicas.max > var.replicas.min ? 1 : 0
  metadata {
    name = var.name
  }

  spec {
    min_replicas = var.replicas.min
    max_replicas = var.replicas.max

    scale_target_ref {
      kind = "Deployment"
      name = var.name
    }
  }
}
