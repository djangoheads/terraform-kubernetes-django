locals {
  namespace = "simple-namespace"
  name      = "simple-service"
  image = {
    name = "simple/image"
    tag  = "version"
  }
  config  = file("${path.module}/data/config.yaml")
  secrets = file("${path.module}/data/secrets.encrypted.yaml")
}
