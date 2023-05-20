module "migrate" {
  source = "github.com/djangoheads/terraform-kubernetes-django"
  
  role = "command"
  namespace = var.namespace
  name = "${var.name}-migrate"
  image = var.image
  config = local.config
  secrets = local.secrets

  command = ["migrate"]
}


module "server" {
  source = "github.com/djangoheads/terraform-kubernetes-django"

  role = "server"
  namespace = var.namespace
  name = "${var.name}-app"
  image = var.image
  config = local.config
  secrets = local.secrets
  
  depends_on = [ 
    module.migrate
  ]
}


resource "kubernetes_ingress" "main" {
  metadata {
    name = var.name
    namespace = var.namespace
  }

  spec {
    rule {
      host = "*"
      http {
        path {
          path = "/"
          backend {
            service_name = module.server.service_name
            service_port = 80
          }
        }
      }
    }
  }
  wait_for_load_balancer = true
}