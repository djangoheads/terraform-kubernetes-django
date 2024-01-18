

module "config" {
  source = "../dynaconf"

  name = var.name
  namespace = var.namespace

  dynaconf = var.dynaconf
}