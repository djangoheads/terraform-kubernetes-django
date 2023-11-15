resource "kubernetes_service" "server" {
  count = var.role == "server" ? 1 : 0
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
      target_port = 8000
    }
    type = "NodePort"
  }
}
