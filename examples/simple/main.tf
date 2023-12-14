module "migrate" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django/modules/command?ref=v0.1.0"
  source = "../../modules/command"

  namespace = var.namespace
  name    = "${var.name}-migrate"

  dynaconf  = {
    config  = local.config
    secrets = local.secrets
  }

  # Specific options
#    image     = local.image
}

module "server" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django/modules/server?ref=v0.1.0"
  source = "../../modules/server"

  namespace = var.namespace
  name    = "${var.name}-migrate"

  dynaconf  = {
    config  = local.config
    secrets = local.secrets
  }
}

module "ingress" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../modules/ingress"
  cloud   = "none"

  # Common options
  namespace = var.namespace
  name = "${var.name}-main"

  # Specific options

  rules = [{
    host = "admin.somedomain.com"
    paths = [{
      path = "/admin/"
      backend = {
        service = module.server.service_name
        port    = 80
      }
    }]
  }]
}
