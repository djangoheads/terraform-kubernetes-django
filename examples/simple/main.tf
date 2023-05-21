module "migrate" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"
  role = "command"
  
  # Common options
  namespace = var.namespace
  image = var.image
  config = yamlencode(merge(yamldecode(local.config), {"ANOTHER": "VALUE"}))
  secrets = local.secrets
  
  # Specific options
  name = "${var.name}-migrate"
  command = ["migrate"]
}

module "server" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"
  role = "server"

  # Common options
  namespace = var.namespace
  image = var.image
  config = local.config
  secrets = local.secrets

  # Specific options
  name = "${var.name}-server"
  
  depends_on = [ 
    module.migrate
  ]
}

module "ingress" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"
  role = "ingress"

  # Common options
  namespace = var.namespace

  # NOTE: NOT USED, TODO: REFACTOR, BUT REQUIRED TO PUT HERE
  image = var.image
  config = local.config
  secrets = local.secrets

  # Specific options
  name = "${var.name}-ingress"

  ingress = [{
    host = "admin.somedomain.com"
    paths = [{
      path = "/admin/"
      backend = {
        service = module.server.service_name
        port = 80
      }
    }]
  }]
  
  depends_on = [ 
    module.migrate
  ]
}