resource "kubernetes_deployment" "server" {
  count = contains(["server", "worker"], var.role) ? 1 : 0
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    replicas = var.replicas.min
    selector {
      match_labels = {
        service = var.name
      }
    }
    template {
      metadata {
        labels = {
          service = var.name
        }
      }
      spec {
        init_container {
          name    = "init-container"
          image   = var.image
          command = ["sh", "-c"]
          args    = var.init_command
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
        }
        container {
          image   = var.image
          name    = "main"
          command = var.command
          args    = var.args
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }

          # Server part
          dynamic "port" {
            for_each = var.role == "server" ? [1] : []
            content {
              container_port = var.port
            }
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
