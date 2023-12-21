data "kubernetes_config_map" "dynaconf" {
  metadata {
    name      = "${var.name}-dynaconf"
    namespace = var.namespace
  }
}
data "kubernetes_secret" "dynaconf" {
  metadata {
    name      = "${var.name}-dynaconf"
    namespace = var.namespace
  }
}
resource "kubernetes_deployment" "server" {
  depends_on = [ module.config ]
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
#        init_container {
#          name    = "init-container"
#          image   = var.image
#          command = ["sh", "-c"]
#          args    = var.init_command
#          dynamic "env" {
#            for_each = var.environment
#            content {
#              name  = env.key
#              value = env.value
#            }
#          }
#        }
        container {
          image   = var.image
          name    = "main"
          command = var.command
          args    = var.args
           dynamic "env" {
            for_each = data.kubernetes_secret.dynaconf.data
            content {
              name  = env.key
              value_from {
                secret_key_ref {
                  name = "${var.name}-dynaconf"
                  key  = env.key
                }
              }
            }
          }

          # Variables from ConfigMap
          dynamic "env" {
            for_each = data.kubernetes_config_map.dynaconf.data
            content {
              name  = env.key
              value_from {
                config_map_key_ref {
                  name = "${var.name}-dynaconf"
                  key  = env.key
                }
              }
            }
          }
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
          # volume_mount {
          #   name       = "${var.name}-settings"
          #   mount_path = "/var/etc/config"
          #   read_only  = true
          # }
          # volume_mount {
          #   name       = "${var.name}-secrets"
          #   mount_path = "/var/etc/secrets"
          #   read_only  = true
          # }
        }
        # volume {
        #   name = "${var.name}-settings"
        #   config_map {
        #     name = "${var.name}-dynaconf"
        #   }
        # }
        # volume {
        #   name = "${var.name}-secrets"
        #   secret {
        #     secret_name = "${var.name}-dynaconf"
        #   }
        # }
      }
    }
  }

  wait_for_rollout = var.wait

  depends_on = [
    module.config,
  ]
}

# resource "kubernetes_horizontal_pod_autoscaler" "autoscaler" {
#   metadata {
#     name = var.name
#   }

#   spec {
#     min_replicas = var.replicas.min
#     max_replicas = var.replicas.max

#     scale_target_ref {
#       kind = "Deployment"
#       name = var.name
#     }
#   }
# }


resource "kubernetes_service" "server" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.name
    }
    port {
      name        = "main"
      protocol    = "TCP"
      port        = var.port
      target_port = var.target_port
    }
  }
}
