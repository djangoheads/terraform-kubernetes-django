resource "kubernetes_service" "server" {
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