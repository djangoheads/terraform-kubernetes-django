

module "config" {
  source = "../config"

  name = var.name
  namespace = var.namespace

  dynaconf = var.dynaconf
}