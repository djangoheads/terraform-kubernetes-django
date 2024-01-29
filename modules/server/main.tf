resource "kubernetes_deployment" "server" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
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
      api_version = "apps/v1"
      kind = "Deployment"
      name = var.name
    }
    # metric {
		# 	type = "Resource"
		# 	resource {
		# 		name = "cpu"
		# 		target {
		# 			type = "Utilization"
		# 			average_utilization = 60
		# 		}
		# 	}
		# }
    # metric {
		# 	type = "Resource"
		# 	resource {
		# 		name = "memory"
		# 		target {
		# 			type = "Utilization"
		# 			average_utilization = 60
		# 		}
		# 	}
		# }
  }
  depends_on = [
    kubernetes_deployment.server
  ]
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
