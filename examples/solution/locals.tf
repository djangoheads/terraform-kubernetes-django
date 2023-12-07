locals {
  name      = "service"
  config  = file("${path.module}/data/config.yaml")
  secrets = file("${path.module}/data/secrets.encrypted.yaml")
}