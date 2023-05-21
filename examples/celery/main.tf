module "migrate" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"
  
  role = "command"
  namespace = var.namespace
  name = "${var.name}-migrate"
  image = var.image
  config = local.config
  secrets = local.secrets

  command = ["migrate"]
}


module "worker" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role = "server"
  namespace = var.namespace
  name = "${var.name}-worker"
  image = var.image
  config = local.config
  secrets = local.secrets
  
  depends_on = [ 
    module.migrate
  ]
}

module "beat" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role = "server"
  namespace = var.namespace
  name = "${var.name}-beat"
  image = var.image
  config = local.config
  secrets = local.secrets
  replicas = {
    max = 1
    min = 1
  }
  
  depends_on = [ 
    module.worker,
    module.migrate
  ]
}