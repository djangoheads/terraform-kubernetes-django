

###########
# COMMAND #
###########


resource "kubernetes_job" "main" {
  count = var.role == "command" ? 1 : 0
  metadata {
    namespace = var.namespace
    name = var.name
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name = "main"
          image = "${var.image.name}:${var.image.tag}:"
          command = var.command
        }
        restart_policy = "Never"
      }
    }
  }
  wait_for_completion = var.wait
}


##########
# SERVER #
##########

resource "kubernetes_deployment" "main" {
  count = var.role == "server" ? 1 : 0
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
          port {
            container_port = var.port
          }
          readiness_probe {
            initial_delay_seconds = var.readiness.delay
            http_get {
              port = var.readiness.port
              path = var.readiness.path
            }
          }
        }
      }
    }
  }
  wait_for_rollout = var.wait
}


resource "kubernetes_service" "main" {
  count = var.role == "server" ? 1 : 0
  metadata {
    name = var.name
    namespace = var.namespace
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "${var.namespace}-${var.name}-main"
    }
    port {
      name = "main"
      protocol = "TCP"
      port = 80
      target_port = 8000
    }
  }
}