resource "kubernetes_ingress_v1" "main_ingress" {
  count       = var.cloud == "aws" ? 1 : 0
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = var.aws_annotation
  }

  spec {
    dynamic "rule" {
      for_each = var.rules
      content {
        host = rule.value["host"]
        http {
          dynamic "path" {
            for_each = rule.value["paths"]
            content {
              path      = path.value["path"]
              path_type = "Prefix"
              backend {
                service {
                  name = path.value["backend"].service
                  port {
                    number = path.value["backend"].port
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
