provider "kubernetes" {
  config_context_cluster = "minikube"
  config_path            = "~/.kube/config"
}
module "storage" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "server"
  namespace = local.namespace
  name      = "${local.name}-storage"
  image     =  local.services_config.storage.image
  config    = local.config
  secrets   = local.secrets
  env_vars = local.env_vars
  port =  local.services_config.storage.x-port
}

module "migrate" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "command"
  namespace = local.namespace
  name      = "${local.name}-migrate"
  image     = local.services_config.migration.image
  config    = local.config
  secrets   = local.secrets
  env_vars = local.env_vars

  command = ["/home/app/bin/entrypoint.sh"]
  args = ["${local.services_config.migration.command}"]
  depends_on = [
    module.storage
  ]
}

module "migrate-user" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "command"
  namespace = local.namespace
  name      = "${local.name}-migrate-user"
  image     = local.services_config.migration-user.image
  config    = local.config
  secrets   = local.secrets
  env_vars = local.env_vars

  command = ["/home/app/bin/entrypoint.sh"]
  args = ["${local.services_config.migration-user.command}"]
  depends_on = [
    module.migrate
  ]
}

module "backend" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "server"
  namespace = local.namespace
  name      = "${local.name}-backend"
  image     =  local.services_config.backend.image
  config    = local.config
  secrets   = local.secrets
  port =  local.services_config.backend.x-port
  command = ["/home/app/bin/entrypoint.sh"]
  args = ["${local.services_config.backend.command}"]
  env_vars = local.env_vars

  depends_on = [
    module.migrate-user
  ]
}