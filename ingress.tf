resource "kubernetes_ingress" "main" {
  count = var.role == "ingress" ? 1 : 0
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    dynamic "rule" {
      for_each = var.ingress
      content {
        host = rule.value["host"]
        http {
          dynamic "path" {
            for_each = rule.value["paths"]
            content {
              path = path.value["path"]
              backend {
                service_name = path.value["backend"].service
                service_port = path.value["backend"].port
              }
            }
          }
        }
      }
    }
  }
  wait_for_load_balancer = true
}
