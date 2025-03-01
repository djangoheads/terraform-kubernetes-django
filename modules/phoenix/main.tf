resource "kubernetes_deployment" "default" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }
  spec {
    replicas = var.enable_autoscaler ? null : var.replica_count
    strategy {
      rolling_update {
        max_surge       = var.max_surge
        max_unavailable = var.max_unavailable
      }
    }
    selector {
      match_labels = {
        service = var.name
      }
    }
    template {
      metadata {
        labels = merge({
          service         = var.name
          config_revision = var.config_revision
          secret_revision = var.secret_revision
        }, var.labels)
      }
      spec {
        security_context {
          fs_group = var.fs_group
        }
        dynamic "init_container" {
          for_each = var.init_command
          content {
            name              = "init-container"
            image             = var.init_image
            command           = ["sh", "-c"]
            args              = var.init_command
            image_pull_policy = var.image_pull_policy
            working_dir       = var.init_working_dir
            dynamic "env" {
              for_each = var.env_vars
              content {
                name  = env.key
                value = env.value
              }
            }
            env_from {
              config_map_ref {
                name = var.configmap_name
              }
            }
            env_from {
              secret_ref {
                  name = var.secret_name
              }
            }
          }
        }
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
          port {
            container_port = var.container_port
          }
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
          env_from {
              config_map_ref {
                name = var.configmap_name
              }
            }
          env_from {
            secret_ref {
                name = var.secret_name
            }
          }
          dynamic "volume_mount" {
            for_each = var.persistence_enabled ? [1] : []
            content {
              name       = "${var.name}-pvc"
              mount_path = var.pvc_mount_path
            }
          }
          dynamic "readiness_probe" {
            for_each = var.readiness
            content {
              dynamic "http_get" {
                for_each = readiness_probe.value.http_get != null ? readiness_probe.value.http_get : []
                content {
                  path = http_get.value["path"]
                  port = http_get.value["port"]
                }
              }
              dynamic "exec" {
                for_each = readiness_probe.value.exec != null ? readiness_probe.value.exec : []
                content {
                  command = exec.value.command
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
        dynamic "volume" {
          for_each = var.persistence_enabled ? [1] : []
          content {
            name = "${var.name}-pvc"

            persistent_volume_claim {
              claim_name = var.name
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


resource "kubernetes_service" "default" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = merge({
    }, var.service_annotation)
  }
  spec {
    selector = {
      service = var.name
    }
    port {
      name        = "main"
      protocol    = "TCP"
      port        = var.service_port
      target_port = var.service_target_port
    }
    type = "NodePort"
  }
}

resource "kubernetes_pod_disruption_budget_v1" "default" {
  metadata {
    name      = "${var.name}-pdb"
    namespace = var.namespace
  }
  spec {
    min_available   = var.pdb_min_available
    max_unavailable = var.pdb_max_unavailable
    selector {
      match_labels = {
        service = var.name
      }
    }
  }
}
