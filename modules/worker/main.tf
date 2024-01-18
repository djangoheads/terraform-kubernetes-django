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
          dynamic "readiness_probe" {
            for_each = var.readiness
            content {
              dynamic "http_get" {
                for_each = readiness_probe.value["http_get"]
                content {
                  path = http_get.value["path"]
                  port = http_get.value["port"]
                }
              }
              initial_delay_seconds = readiness_probe.value["delay"]
              period_seconds        = readiness_probe.value["period_seconds"]
            }
          }
          dynamic "liveness_probe" {
            for_each = var.liveness
            content {
              dynamic "http_get" {
                for_each = liveness_probe.value["http_get"]
                content {
                  path = http_get.value["path"]
                  port = http_get.value["port"]
                }
              }
              initial_delay_seconds = liveness_probe.value["delay"]
              period_seconds        = liveness_probe.value["period_seconds"]
            }
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
    module.config,
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

