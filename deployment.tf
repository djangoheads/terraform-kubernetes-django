resource "kubernetes_deployment" "server" {
  count = contains(["server", "worker"], var.role) ? 1 : 0
  metadata {
    name = var.name
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name" = "${var.namespace}-${var.name}-main"
    }
  }
  spec {
    replicas = var.replicas.min
    template {
      metadata {}
      spec {
        container {
          image = "${var.image.name}:${var.image.tag}"
          name  = "main"

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
          dynamic "readiness_probe" {
            for_each = var.role == "server" ? [1] : []
            content {
              initial_delay_seconds = var.readiness.delay
              http_get {
                port = var.readiness.port
                path = var.readiness.path
              }  
            }
          }
          dynamic "liveness_probe" {
            for_each = var.role == "server" ? [1] : []
            content {
              initial_delay_seconds = var.liveness.delay
              http_get {
                port = var.liveness.port
                path = var.liveness.path
              }  
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

        volume {
          name = var.name
          secret {
            secret_name = var.name
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
