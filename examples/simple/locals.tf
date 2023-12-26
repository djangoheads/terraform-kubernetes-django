locals {
  settings  = file(var.config)
  secrets = file(var.secrets)
}
