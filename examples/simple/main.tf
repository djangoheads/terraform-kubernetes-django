module "migrate" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django/modules/command?ref=v0.1.0"
  source = "../../modules/command"

  namespace = var.namespace
  name    = "${var.name}-migrate"

  dynaconf  = {
    settings  = local.settings
    secrets = local.secrets
  }

  # Specific options
  image     = var.image
  env_vars = {
    DJANGO_SECRET_KEY = "local",
    DJANGO_DEBUG = "1",
    DJANGO_DATABASES__default__NAME = "/tmp/db.sqlite3"
  }
  command = [ "django-admin" ]
  args = [ "migrate", "--noinput" ]
  wait = false
}

module "server" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django/modules/server?ref=v0.1.0"
  source = "../../modules/server"

  namespace = var.namespace
  name    = "${var.name}-server"

  dynaconf  = {
    settings  = local.settings
    secrets = local.secrets
  }
  # Specific options
  image     = var.image
  env_vars = {
    DJANGO_SECRET_KEY = "local",
    DJANGO_DEBUG = "1",
    DJANGO_DATABASES__default__NAME = "/tmp/db.sqlite3"
  }
  command = ["/home/app/bin/entrypoint.sh"]
  args = ["devserver"] 
  port = 8000
  target_port = 8000
  wait = true
}

module "ingress" {
  # Main options 
  # source = "github.com/djangoheads/terraform-kubernetes-django"
  source = "../../modules/default_ingress"

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
