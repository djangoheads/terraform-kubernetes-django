module "migrate" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "command"
  namespace = local.namespace
  name      = "${local.name}-migrate"
  image     = var.image
  config    = local.config
  secrets   = local.secrets
  env_vars = var.env_vars
  command = ["django-admin"]
  args = ["migrate", "--noinput"]
  depends_on = [ postgresql_database.backend ]
}

module "migrate-user" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"

  role      = "command"
  namespace = local.namespace
  name      = "${local.name}-migrate-user"
  image     = var.image
  config    = local.config
  secrets   = local.secrets
  env_vars = var.env_vars
  command = ["/home/app/bin/entrypoint.sh"]
  args = ["createsuperuser"]
  depends_on = [ postgresql_database.backend, module.migrate]
}

module "backend" {
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../"
  role      = "server"
  namespace = local.namespace
  name      = "${local.name}-backend"
  image     =  var.image
  config    = local.config
  secrets   = local.secrets
  port =  8000
  command = ["/home/app/bin/entrypoint.sh"]
  args = ["devserver"]
  init_command = ["for i in {1..100}; do sleep 1; if django-admin migrate --check; then exit 0; fi; done; exit 1"]
  env_vars = var.env_vars
  depends_on = [ postgresql_database.backend ]
}