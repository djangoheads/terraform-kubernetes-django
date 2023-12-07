module "migrate" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "command"
  namespace = local.namespace
  name      = "${local.name}-migrate"
  image     = local.image
  config    = local.config
  secrets   = local.secrets

  command = ["migrate"]
}


module "worker" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "job"
  namespace = local.namespace
  name      = "${local.name}-worker"
  image     = local.image
  config    = local.config
  secrets   = local.secrets

  depends_on = [
    module.migrate
  ]
}

module "beat" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "server"
  namespace = local.namespace
  name      = "${local.name}-beat"
  image     = local.image
  config    = local.config
  secrets   = local.secrets
  replicas = {
    max = 1
    min = 1
  }

  depends_on = [
    module.worker,
    module.migrate
  ]
}
