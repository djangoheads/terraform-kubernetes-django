module "dynaconf" {
  source = "../dynaconf"

  name = var.name
  namespace = var.namespace

  dynaconf = var.dynaconf
}