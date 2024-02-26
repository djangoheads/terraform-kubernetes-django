resource "kubernetes_deployment" "default" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    replicas = var.enable_autoscaler ? null : var.replica_count
    strategy {
      rolling_update {
        max_surge = var.max_surge
      }
    }
    selector {
      match_labels = {
        service = var.name
      }
    }
    template {
      metadata {
        labels = {
          service         = var.name
          config_revision = var.config_revision
          secret_revision = var.secret_revision
        }
      }
      spec {
        container {
          image             = var.image
          name              = "main"
          command           = var.command
          args              = var.args
          image_pull_policy = var.image_pull_policy
          working_dir       = var.working_dir
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
              initial_delay_seconds = readiness_probe.value["initial_delay_seconds"]
              period_seconds        = readiness_probe.value["period_seconds"]
              timeout_seconds       = readiness_probe.value["timeout_seconds"]
              failure_threshold     = readiness_probe.value["failure_threshold"]
              success_threshold     = readiness_probe.value["success_threshold"]
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
              initial_delay_seconds = liveness_probe.value["initial_delay_seconds"]
              period_seconds        = liveness_probe.value["period_seconds"]
              timeout_seconds       = liveness_probe.value["timeout_seconds"]
              failure_threshold     = liveness_probe.value["failure_threshold"]
              success_threshold     = liveness_probe.value["success_threshold"]
            }
          }
        }
        volume {
          name = "${var.name}-dynaconf-settings"
          projected {
            sources {
              config_map {
                name     = var.configmap_name
                optional = true
                items {
                  key  = var.configmap_key
                  path = var.configmap_path
                }
              }
              secret {
                name     = var.secret_name
                optional = true
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

  wait_for_rollout = var.wait

}

resource "kubernetes_horizontal_pod_autoscaler" "default" {
  count = var.enable_autoscaler ? 1 : 0
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    target_cpu_utilization_percentage = var.cpu_target

    min_replicas = var.replicas.min
    max_replicas = var.replicas.max

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.name
    }
  }
}

resource "kubernetes_pod_disruption_budget" "pdb" {
  metadata {
    name      = "${var.name}-pdb"
    namespace = var.namespace
  }
  spec {
    min_available = var.pdb_min_available
    selector {
      match_labels = {
        service = var.name
      }
    }
  }
}
