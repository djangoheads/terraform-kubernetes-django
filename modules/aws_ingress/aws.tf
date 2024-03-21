resource "kubernetes_ingress_v1" "default" {
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = merge({
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "kubernetes.io/ingress.class"                        = "alb"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/certificate-arn"          = var.aws.certificate
      "alb.ingress.kubernetes.io/load-balancer-attributes" = "routing.http.preserve_host_header.enabled=true,idle_timeout.timeout_seconds=300"
    }, var.aws_annotation)
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
