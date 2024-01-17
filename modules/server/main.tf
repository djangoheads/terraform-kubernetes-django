resource "kubernetes_deployment" "server" {
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
        dynamic "init_container" {
          for_each = var.init_command
          content {
            name    = "init-container"
          image   = var.image
          command = ["sh", "-c"]
          args    = var.init_command
          image_pull_policy = var.image_pull_policy
          dynamic "env" {
              for_each = var.env_vars
              content {
                name  = env.key
                value = env.value
              }
            }
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
        }
        container {
          image   = var.image
          name    = "main"
          command = var.command
          args    = var.args
          image_pull_policy = var.image_pull_policy
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
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
          liveness_probe {
            http_get {
              path = var.liveness.path
              port = var.liveness.port
            }
            initial_delay_seconds = var.liveness.delay
            period_seconds        = 5
          }
          readiness_probe {
            http_get {
              path = var.readiness.path
              port = var.readiness.port
            }
            initial_delay_seconds = var.readiness.delay
            period_seconds        = 5
          }
        }
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

  wait_for_rollout = var.wait

  depends_on = [
    module.dynaconf,
  ]
}

resource "kubernetes_horizontal_pod_autoscaler" "autoscaler" {
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


resource "kubernetes_service" "server" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    selector = {
      service = var.name
    }
    port {
      name        = "main"
      protocol    = "TCP"
      port        = var.port
      target_port = var.target_port
    }
  }
}
