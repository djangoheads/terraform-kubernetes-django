locals {
  namespace = "celery-namespace"
  name      = "celery-service"
  image = {
    name = "celery/image"
    tag  = "version"
  }
  config  = file("${path.module}/data/config.yaml")
  secrets = file("${path.module}/data/secrets.encrypted.yaml")
}
