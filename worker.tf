resource "kubernetes_deployment" "worker" {
  count = var.role == "worker" ? 1 : 0
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